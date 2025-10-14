import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:onepali/src/src.dart';

class PrintablesProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<PrintableModel> _printables = [];
  List<PrintableModel> get printables => _printables;

  final Set<String> _selectedWorksheets = {};
  Set<String> get selectedWorksheets => _selectedWorksheets;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  double _downloadProgress = 0.0;
  double get downloadProgress => _downloadProgress;

  String _downloadingWorksheetId = '';
  String get downloadingWorksheetId => _downloadingWorksheetId;

  // Filtered printables based on search
  List<PrintableModel> get filteredPrintables {
    if (_searchQuery.isEmpty) {
      return _printables;
    }
    return _printables.where((printable) {
      return printable.title.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          printable.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          printable.chapterId.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  Future<void> fetchPrintables() async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    bool isGuest = GuestUtil.isGuestUser();

    if (user == null && !isGuest) {
      logger.e('User is not authenticated and not a guest user.');
      handleError("User not signed in.");
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.printableCollection)
          .get();

      final List<Map<String, dynamic>> printablesList = querySnapshot.docs
          .map((doc) => doc.data())
          .toList();

      _printables.clear();
      _printables.addAll(printableModelFromJson(jsonEncode(printablesList)));

      setStatus(DataFetchStatus.success);

      logger.d('Fetched ${_printables.length} printables');
    } catch (e) {
      logger.e('Error fetching printables: $e');
      handleError(e.toString());
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleWorksheetSelection(String worksheetId) {
    if (_selectedWorksheets.contains(worksheetId)) {
      _selectedWorksheets.remove(worksheetId);
    } else {
      _selectedWorksheets.add(worksheetId);
    }
    notifyListeners();
  }

  void selectAllWorksheets(PrintableModel printable) {
    for (final lesson in printable.lessons) {
      _selectedWorksheets.add(lesson.id);
    }
    notifyListeners();
  }

  void deselectAllWorksheets(PrintableModel printable) {
    for (final lesson in printable.lessons) {
      _selectedWorksheets.remove(lesson.id);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedWorksheets.clear();
    notifyListeners();
  }

  // Download single worksheet using secure download utility
  Future<bool> downloadWorksheet(PLesson lesson, String printableTitle) async {
    try {
      _isDownloading = true;
      _downloadingWorksheetId = lesson.id;
      _downloadProgress = 0.0;
      notifyListeners();

      // Validate lesson data first
      if (lesson.worksheet.pdfUrl.isEmpty) {
        throw Exception('PDF URL is empty');
      }

      logger.d('Downloading worksheet: ${lesson.title}');
      logger.d('PDF URL: ${lesson.worksheet.pdfUrl}');

      // Create safe filename
      final String filename = '${printableTitle}_${lesson.title}.pdf'
          .replaceAll(RegExp(r'[^\w\s-.]'), '') // Remove invalid characters
          .replaceAll(RegExp(r'\s+'), '_') // Replace spaces with underscores
          .trim();

      // Ensure filename is valid
      if (filename.isEmpty || filename == '.pdf') {
        throw Exception('Could not generate valid filename');
      }

      logger.d('Generated filename: $filename');

      // Use the new secure download utility
      final String? downloadedPath = await FileDownloadUtility.downloadFile(
        url: lesson.worksheet.pdfUrl,
        filename: filename,
        folderName: 'O Nepali',
        onProgress: (progress) {
          _downloadProgress = progress;
          notifyListeners();
        },
      );

      _isDownloading = false;
      _downloadingWorksheetId = '';
      _downloadProgress = 0.0;
      notifyListeners();

      if (downloadedPath != null && downloadedPath.isNotEmpty) {
        // Verify the file actually exists and has content
        final downloadedFile = File(downloadedPath);
        if (await downloadedFile.exists()) {
          final fileSize = await downloadedFile.length();
          if (fileSize > 0) {
            logger.d('Download successful: $downloadedPath ($fileSize bytes)');

            // Get user-friendly location description
            final locationDescription =
                await FileDownloadUtility.getDownloadLocationDescription();

            if (Platform.isIOS) {
              showCustomToaster(
                'Downloaded: $filename\nSaved to: $locationDescription',
              );
              // Share file on iOS for better user experience
              await FileDownloadUtility.shareFile(downloadedPath, filename);
            } else {
              // For Android, provide more helpful feedback
              if (downloadedPath.contains('/Download/')) {
                showCustomToaster(
                  '✅ Downloaded: $filename\n📁 Find in: $locationDescription\n💡 Open your Files app to view',
                );
              } else if (downloadedPath.contains('Android/data')) {
                showCustomToaster(
                  '✅ Downloaded: $filename\n📁 Location: $locationDescription\n💡 Use Files app ➜ Browse ➜ This device',
                );
              } else {
                showCustomToaster(
                  '✅ Downloaded: $filename\n📁 Saved to: $locationDescription\n💡 Use Share button for easier access',
                );

                // If file is in internal storage, offer to share it immediately
                try {
                  await FileDownloadUtility.shareFile(downloadedPath, filename);
                } catch (e) {
                  logger.w('Could not auto-share file: $e');
                }
              }
            }

            return true;
          } else {
            throw Exception('Downloaded file is empty');
          }
        } else {
          throw Exception('Downloaded file not found');
        }
      } else {
        throw Exception('Download failed - no file path returned');
      }
    } catch (e) {
      _isDownloading = false;
      _downloadingWorksheetId = '';
      _downloadProgress = 0.0;
      notifyListeners();

      logger.e('Error downloading worksheet: $e');

      // Provide more specific error messages
      String errorMessage = 'Failed to download worksheet';
      if (e.toString().contains('timeout')) {
        errorMessage =
            'Download timeout - please check your internet connection';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('network') ||
          e.toString().contains('connection')) {
        errorMessage = 'Network error - please check your internet connection';
      } else if (e.toString().contains('storage') ||
          e.toString().contains('permission')) {
        errorMessage = 'Storage access error - files saved to app folder';
      } else if (e.toString().contains('PDF URL is empty')) {
        errorMessage = 'Invalid worksheet data - please try again';
      } else if (e.toString().contains('space')) {
        errorMessage = 'Not enough storage space';
      }

      showCustomToaster(errorMessage, isError: true);
      return false;
    }
  }

  // Download all worksheets in a printable using secure download utility
  Future<void> downloadAllWorksheets(PrintableModel printable) async {
    try {
      _isDownloading = true;
      notifyListeners();

      int successCount = 0;
      int totalCount = printable.lessons.length;

      for (int i = 0; i < printable.lessons.length; i++) {
        final lesson = printable.lessons[i];
        _downloadingWorksheetId = lesson.id;
        _downloadProgress = i / totalCount;
        notifyListeners();

        final success = await downloadWorksheet(lesson, printable.title);
        if (success) {
          successCount++;
        }
      }

      _isDownloading = false;
      _downloadingWorksheetId = '';
      _downloadProgress = 0.0;
      notifyListeners();

      // Get user-friendly location description
      final locationDescription =
          await FileDownloadUtility.getDownloadLocationDescription();

      if (successCount == totalCount) {
        showCustomToaster(
          'All worksheets downloaded successfully!\nSaved to: $locationDescription',
        );
      } else if (successCount > 0) {
        showCustomToaster(
          'Downloaded $successCount of $totalCount worksheets\nSaved to: $locationDescription',
        );
      } else {
        showCustomToaster('Failed to download worksheets', isError: true);
      }
    } catch (e) {
      _isDownloading = false;
      _downloadingWorksheetId = '';
      _downloadProgress = 0.0;
      notifyListeners();

      logger.e('Error downloading all worksheets: $e');
      showCustomToaster('Failed to download worksheets', isError: true);
    }
  }

  void handleError(String error) {
    _status = DataFetchStatus.error;
    showCustomToaster(error, isError: true);
    notifyListeners();
  }

  void setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  /// Debug method to test download functionality
  Future<void> testDownloadCapability() async {
    try {
      logger.d('Testing download capability...');

      // Get storage info for debugging
      final storageInfo = <String, dynamic>{};

      if (Platform.isAndroid) {
        try {
          final externalDir = await getExternalStorageDirectory();
          storageInfo['externalDir'] = externalDir?.path ?? 'null';

          final documentsDir = await getApplicationDocumentsDirectory();
          storageInfo['documentsDir'] = documentsDir.path;

          // Test creating a file
          final testDir = await FileDownloadUtility.getBestDownloadDirectory(
            'test',
          );
          storageInfo['testDir'] = testDir?.path ?? 'null';

          if (testDir != null) {
            final testFile = File('${testDir.path}/test.txt');
            await testFile.writeAsString('test content');
            final exists = await testFile.exists();
            storageInfo['canCreateFile'] = exists;
            if (exists) {
              await testFile.delete();
            }
          }
        } catch (e) {
          storageInfo['error'] = e.toString();
        }
      }

      logger.d('Storage info: $storageInfo');
      showCustomToaster('Check logs for storage info');
    } catch (e) {
      logger.e('Test download capability error: $e');
      showCustomToaster('Test failed: ${e.toString()}', isError: true);
    }
  }
}
