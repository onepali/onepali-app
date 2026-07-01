import 'dart:io';
import 'package:flutter/services.dart';
import 'package:onepali/src/src.dart';

class StorageService {
  static const MethodChannel _channel = MethodChannel(
    'fun.onepali.app/storage',
  );
  static const String _folderUriKey = 'selected_folder_uri';

  /// Request folder access using SAF (Storage Access Framework)
  /// Returns true if folder was selected and access granted
  static Future<bool> requestFolderAccess() async {
    if (!Platform.isAndroid) {
      logger.e('requestFolderAccess called on non-Android platform');
      return false;
    }

    try {
      logger.d('Calling native pickFolder method...');
      logger.d('This should open the folder picker. Please select a folder.');

      // Add a timeout to prevent hanging forever
      final String? folderUri = await _channel
          .invokeMethod('pickFolder')
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              logger.e('Folder picker timeout - user may have taken too long');
              return null;
            },
          );

      logger.d(
        'pickFolder returned: ${folderUri != null ? "URI received: $folderUri" : "null (cancelled or timeout)"}',
      );

      if (folderUri != null && folderUri.isNotEmpty) {
        logger.d('Saving folder URI: $folderUri');
        await _saveFolderUri(folderUri);
        logger.d('Folder URI saved successfully');
        return true;
      } else {
        logger.w(
          'Folder URI is null or empty - user may have cancelled or picker failed',
        );
        return false;
      }
    } on PlatformException catch (e) {
      logger.e(
        'PlatformException requesting folder access: ${e.code} - ${e.message}',
      );
      if (e.code == 'NO_ACTIVITY') {
        logger.e('No file manager found on device to handle folder selection');
      } else if (e.code == 'FOLDER_PICKER_ERROR') {
        logger.e('Folder picker error: ${e.message}');
      }
      return false;
    } catch (e, stackTrace) {
      logger.e('Error requesting folder access: $e');
      logger.e('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Get the saved folder URI
  static Future<String?> getFolderUri() async {
    final prefs = SharedPreferencesService();
    return await prefs.getStringPref(_folderUriKey);
  }

  /// Save folder URI to SharedPreferences
  static Future<void> _saveFolderUri(String uri) async {
    final prefs = SharedPreferencesService();
    await prefs.setStringPref(_folderUriKey, uri);
  }

  /// Check if folder access has been granted
  static Future<bool> hasFolderAccess() async {
    final uri = await getFolderUri();
    if (uri == null || uri.isEmpty) {
      return false;
    }

    // Verify the URI is still valid
    try {
      if (Platform.isAndroid) {
        final bool isValid = await _channel.invokeMethod('verifyFolderUri', {
          'uri': uri,
        });
        return isValid ?? false;
      }
    } catch (e) {
      logger.e('Error verifying folder URI: $e');
      return false;
    }

    return true;
  }

  /// Save file to the selected folder using SAF
  static Future<bool> saveFileToFolder(
    String filename,
    List<int> fileBytes,
  ) async {
    if (!Platform.isAndroid) {
      logger.e('saveFileToFolder called on non-Android platform');
      return false;
    }

    final folderUri = await getFolderUri();
    logger.d('Folder URI: $folderUri');
    if (folderUri == null || folderUri.isEmpty) {
      logger.e('No folder URI found. Folder not selected.');
      return false;
    }

    try {
      logger.d('Saving file: $filename (${fileBytes.length} bytes)');
      final bool success = await _channel.invokeMethod('saveFile', {
        'folderUri': folderUri,
        'filename': filename,
        'fileBytes': fileBytes,
      });
      logger.d('File save result from native: $success');
      return success ?? false;
    } catch (e, stackTrace) {
      logger.e('Error saving file to folder: $e');
      logger.e('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Clear saved folder URI
  static Future<void> clearFolderAccess() async {
    final prefs = SharedPreferencesService();
    await prefs.deleteSharedPref(_folderUriKey);
  }
}
