import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../core.dart';

/// Utility class for secure file downloads that minimize permission requirements
class FileDownloadUtility {
  /// Download a file to the most appropriate location based on platform and Android version
  /// Returns the file path if successful, null if failed
  static Future<String?> downloadFile({
    required String url,
    required String filename,
    required String folderName,
    Function(double)? onProgress,
  }) async {
    try {
      logger.d('Starting download - URL: $url, Filename: $filename');

      // Check if we can download without broad permissions
      final downloadDir = await getBestDownloadDirectory(folderName);
      if (downloadDir == null) {
        logger.e('Could not determine download directory');
        return null;
      }

      logger.d('Download directory determined: ${downloadDir.path}');
      final filePath = '${downloadDir.path}/$filename';
      final file = File(filePath);

      // Check if file already exists
      if (await file.exists()) {
        logger.d('File already exists: $filePath');
        return filePath;
      }

      logger.d('Starting HTTP download from: $url');

      // Validate URL format
      final uri = Uri.tryParse(url);
      if (uri == null) {
        logger.e('Invalid URL format: $url');
        return null;
      }

      // Download the file with longer timeout for release builds
      final response = await http
          .get(uri)
          .timeout(
            const Duration(minutes: 2), // Longer timeout for release builds
            onTimeout: () {
              throw Exception('Download timeout after 2 minutes');
            },
          );

      logger.d('HTTP response status: ${response.statusCode}');
      logger.d('HTTP response headers: ${response.headers}');
      logger.d('HTTP response body length: ${response.bodyBytes.length}');

      if (response.statusCode == 200) {
        if (response.bodyBytes.isEmpty) {
          logger.e('Response body is empty');
          return null;
        }

        // Ensure directory exists before writing
        await downloadDir.create(recursive: true);

        // Write file with proper error handling
        try {
          await file.writeAsBytes(response.bodyBytes);
          logger.d('File bytes written to: $filePath');
        } catch (writeError) {
          logger.e('Failed to write file: $writeError');
          return null;
        }

        // Verify file was written successfully
        if (await file.exists()) {
          final fileSize = await file.length();
          logger.d(
            'File downloaded successfully: $filePath (${fileSize} bytes)',
          );

          // Additional verification for PDF files
          if (filename.toLowerCase().endsWith('.pdf')) {
            // Check if file starts with PDF signature
            try {
              final bytes = await file.readAsBytes();
              if (bytes.length >= 4) {
                final pdfSignature = String.fromCharCodes(bytes.take(4));
                if (!pdfSignature.startsWith('%PDF')) {
                  logger.w('Downloaded file may not be a valid PDF');
                }
              }
            } catch (e) {
              logger.w('Could not verify PDF signature: $e');
            }
          }

          return filePath;
        } else {
          logger.e('File was not created after write operation');
          return null;
        }
      } else {
        logger.e('Failed to download file: HTTP ${response.statusCode}');
        logger.e('Response reason: ${response.reasonPhrase}');
        if (response.body.isNotEmpty && response.body.length < 1000) {
          logger.e('Response body: ${response.body}');
        }
        return null;
      }
    } catch (e, stackTrace) {
      logger.e('Error downloading file: $e');
      logger.e('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Get the best download directory based on platform and permissions
  static Future<Directory?> getBestDownloadDirectory(String folderName) async {
    if (Platform.isAndroid) {
      return await _getAndroidDownloadDirectory(folderName);
    } else if (Platform.isIOS) {
      return await _getIOSDownloadDirectory(folderName);
    } else {
      // For other platforms, use documents directory
      final documentsDir = await getApplicationDocumentsDirectory();
      final appFolder = Directory('${documentsDir.path}/$folderName');
      if (!await appFolder.exists()) {
        await appFolder.create(recursive: true);
      }
      return appFolder;
    }
  }

  /// Android-specific download directory logic - tries Downloads folder first
  static Future<Directory?> _getAndroidDownloadDirectory(
    String folderName,
  ) async {
    try {
      final int androidVersion = await _getAndroidSdkVersion();
      logger.d('Android SDK version: $androidVersion');

      // Strategy 1: Try public Downloads folder first (what users expect)
      logger.d('Attempting to use public Downloads folder');

      // For Android 10+ (API 29+), we need to be more careful with Downloads access
      if (androidVersion >= 29) {
        logger.d('Android 10+ detected - using scoped storage approach');
        try {
          // Try to use Downloads folder without broad permissions
          final downloadsPath = '/storage/emulated/0/Download';
          final downloadsDir = Directory(downloadsPath);

          if (await downloadsDir.exists()) {
            final appFolder = Directory('${downloadsDir.path}/$folderName');

            // Try to create the folder
            if (!await appFolder.exists()) {
              logger.d('Creating Downloads app folder: ${appFolder.path}');
              await appFolder.create(recursive: true);
            }

            // Test write permission
            final testFile = File('${appFolder.path}/.test_scoped');
            await testFile.writeAsString('test');
            final canWrite = await testFile.exists();
            if (canWrite) {
              await testFile.delete();
              logger.d(
                'Successfully using Downloads folder (scoped): ${appFolder.path}',
              );
              return appFolder;
            }
          }
        } catch (e) {
          logger.w('Cannot access Downloads folder with scoped storage: $e');
        }
      } else {
        // Android 9 and below - try direct access first
        logger.d('Android 9 or below - trying direct Downloads access');
        try {
          final downloadsPath = '/storage/emulated/0/Download';
          final downloadsDir = Directory(downloadsPath);

          if (await downloadsDir.exists()) {
            final appFolder = Directory('${downloadsDir.path}/$folderName');

            if (!await appFolder.exists()) {
              await appFolder.create(recursive: true);
            }

            // Test write permission
            final testFile = File('${appFolder.path}/.test_direct');
            await testFile.writeAsString('test');
            await testFile.delete();

            logger.d(
              'Successfully using Downloads folder (direct): ${appFolder.path}',
            );
            return appFolder;
          }
        } catch (e) {
          logger.w('Direct Downloads access failed: $e');
        }
      }

      // Strategy 2: For Android 9 and below, try with legacy permissions
      if (androidVersion <= 28) {
        logger.d('Android 9 or below - requesting legacy storage permission');
        final hasPermission = await _requestLegacyStoragePermission();
        if (hasPermission) {
          try {
            final downloadsPath = '/storage/emulated/0/Download';
            final downloadsDir = Directory(downloadsPath);

            if (await downloadsDir.exists()) {
              final appFolder = Directory('${downloadsDir.path}/$folderName');
              if (!await appFolder.exists()) {
                await appFolder.create(recursive: true);
              }

              // Test write permission
              final testFile = File('${appFolder.path}/.test_legacy');
              await testFile.writeAsString('test');
              await testFile.delete();

              logger.d(
                'Successfully using Downloads with legacy permission: ${appFolder.path}',
              );
              return appFolder;
            }
          } catch (e) {
            logger.w('Cannot use Downloads folder with legacy permission: $e');
          }
        }
      }

      // Strategy 3: Use app's external files directory (still accessible to users)
      logger.d('Using app external files directory');
      try {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final appFolder = Directory('${externalDir.path}/$folderName');
          if (!await appFolder.exists()) {
            await appFolder.create(recursive: true);
          }

          // Test write permission
          final testFile = File('${appFolder.path}/.test_external');
          await testFile.writeAsString('test');
          await testFile.delete();

          logger.d(
            'Successfully using app external directory: ${appFolder.path}',
          );
          return appFolder;
        } else {
          logger.w('External storage directory is null');
        }
      } catch (e) {
        logger.w('Error accessing external storage directory: $e');
      }

      // Strategy 4: Last resort - app internal documents directory
      logger.d('Using last resort: app internal documents directory');
      try {
        final documentsDir = await getApplicationDocumentsDirectory();
        final appFolder = Directory('${documentsDir.path}/$folderName');
        if (!await appFolder.exists()) {
          await appFolder.create(recursive: true);
        }

        // Test write permission
        final testFile = File('${appFolder.path}/.test_internal');
        await testFile.writeAsString('test');
        await testFile.delete();

        logger.d(
          'Successfully using app documents directory: ${appFolder.path}',
        );
        return appFolder;
      } catch (e) {
        logger.e('Error accessing app documents directory: $e');
        return null;
      }
    } catch (e) {
      logger.e('Error getting Android download directory: $e');
      return null;
    }
  }

  /// iOS-specific download directory logic
  static Future<Directory?> _getIOSDownloadDirectory(String folderName) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final appFolder = Directory('${documentsDir.path}/$folderName');
      if (!await appFolder.exists()) {
        await appFolder.create(recursive: true);
      }
      return appFolder;
    } catch (e) {
      logger.e('Error getting iOS download directory: $e');
      return null;
    }
  }

  /// Share file using platform share sheet (works on both iOS and Android)
  static Future<void> shareFile(String filePath, String filename) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(filePath)],
            text: 'Downloaded from O Nepali: $filename',
            subject: 'O Nepali Worksheet',
          ),
        );
        logger.d('File shared successfully: $filename');
      } else {
        logger.e('Cannot share file - file does not exist: $filePath');
      }
    } catch (e) {
      logger.e('Error sharing file: $e');
    }
  }

  /// Check if we need storage permission for legacy Android versions
  static Future<bool> _requestLegacyStoragePermission() async {
    try {
      final int androidVersion = await _getAndroidSdkVersion();
      logger.d('Checking storage permission for SDK $androidVersion');

      // Only request storage permission for Android 9 and below
      if (androidVersion <= 28) {
        logger.d('Android 9 or below, checking storage permission');

        if (await Permission.storage.isGranted) {
          logger.d('Storage permission already granted');
          return true;
        }

        logger.d('Requesting storage permission');
        final status = await Permission.storage.request();
        final granted = status.isGranted;
        logger.d('Storage permission request result: $granted');
        return granted;
      }

      // Android 10+ doesn't need storage permission for Downloads
      logger.d('Android 10+, no storage permission needed');
      return true;
    } catch (e, stackTrace) {
      logger.e('Error checking storage permission: $e');
      logger.e('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Get Android SDK version using device_info_plus
  static Future<int> _getAndroidSdkVersion() async {
    if (!Platform.isAndroid) return 0;

    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final sdkVersion = androidInfo.version.sdkInt;
      logger.d('Device SDK version from device_info_plus: $sdkVersion');
      return sdkVersion;
    } catch (e, stackTrace) {
      logger.e('Error getting Android SDK version from device_info_plus: $e');
      logger.e('Stack trace: $stackTrace');

      // Fallback: try alternative method
      try {
        logger.d('Attempting fallback SDK detection method');
        // Use a more conservative approach - assume modern Android if we can access Downloads
        final downloadsPath = '/storage/emulated/0/Download';
        final downloadsDir = Directory(downloadsPath);

        if (await downloadsDir.exists()) {
          // If Downloads directory exists, likely Android 10+ (API 29+)
          logger.d('Downloads directory exists, assuming Android 10+ (SDK 29)');
          return 29;
        } else {
          // If no Downloads directory, assume older Android
          logger.d(
            'Downloads directory not found, assuming Android 9 (SDK 28)',
          );
          return 28;
        }
      } catch (fallbackError) {
        logger.e('Fallback SDK detection also failed: $fallbackError');
        // Return a conservative default that should work with permissions
        logger.w('Using conservative default SDK version 28 (Android 9)');
        return 28;
      }
    }
  }

  /// Get a user-friendly description of where files are saved
  static Future<String> getDownloadLocationDescription() async {
    if (Platform.isAndroid) {
      try {
        // Get the actual directory being used
        final downloadDir = await getBestDownloadDirectory('O Nepali');
        if (downloadDir != null) {
          final path = downloadDir.path;

          if (path.contains('/storage/emulated/0/Download')) {
            return 'Downloads ➜ O Nepali folder';
          } else if (path.contains('Android/data')) {
            return 'Files app ➜ Android/data/fun.onepali.app/files/O Nepali';
          } else if (path.contains('/data/data')) {
            return 'App internal storage (use Share button to save elsewhere)';
          } else {
            return 'App storage folder';
          }
        } else {
          return 'App storage folder';
        }
      } catch (e) {
        return 'App storage folder';
      }
    } else if (Platform.isIOS) {
      return 'App Documents folder (use Share to save elsewhere)';
    } else {
      return 'App Documents folder';
    }
  }

  /// Provide instructions to users on how to find their downloaded files
  static Future<String> getFileAccessInstructions() async {
    if (Platform.isAndroid) {
      try {
        final downloadDir = await getBestDownloadDirectory('O Nepali');
        if (downloadDir != null) {
          final path = downloadDir.path;

          if (path.contains('/storage/emulated/0/Download')) {
            return '''📁 Your files are in the Downloads folder!

How to find them:
1. Open your device's "Files" app
2. Look for "Downloads" folder
3. Find "O Nepali" folder inside
4. Your worksheets are there!

Alternative: Use any file manager app''';
          } else if (path.contains('Android/data')) {
            return '''📁 Your files are saved in app storage!

How to find them:
1. Open your "Files" app
2. Tap "Browse" or "This device"  
3. Navigate to: Internal storage > Android > data > fun.onepali.app > files > O Nepali
4. Your worksheets are there!

💡 Tip: Use the Share button for easier access''';
          } else {
            return '''📁 Your files are in app internal storage!

How to access them:
1. Use the Share button when downloading
2. Save to your preferred location
3. Or find them in the app's private folder

💡 Tip: Share feature copies files to accessible locations''';
          }
        }
      } catch (e) {
        logger.e('Error getting file access instructions: $e');
      }
    }

    return '''📁 Your downloaded files:

• Use the Share button for easy access
• Files are saved in app storage
• Share to Downloads, Google Drive, or other apps''';
  }
}
