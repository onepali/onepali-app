import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
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
      final querySnapshot =
          await _firestore.collection(AppConstants.printableCollection).get();

      final List<Map<String, dynamic>> printablesList =
          querySnapshot.docs.map((doc) => doc.data()).toList();

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

  // Create O Nepali folder in appropriate location based on platform
  Future<Directory> _getOrCreateONepaliFolder() async {
    late Directory documentsDirectory;

    if (Platform.isAndroid) {
      // Android: Use public Documents folder for better accessibility
      final Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        throw Exception('Could not access external storage');
      }

      // Navigate to Documents folder (usually /storage/emulated/0/Documents)
      final String documentsPath = '/storage/emulated/0/Documents';
      documentsDirectory = Directory(documentsPath);

      if (!await documentsDirectory.exists()) {
        await documentsDirectory.create(recursive: true);
      }
    } else {
      documentsDirectory = await getApplicationDocumentsDirectory();
    }

    final Directory oNepaliFolder = Directory(
      '${documentsDirectory.path}/O Nepali',
    );

    if (!await oNepaliFolder.exists()) {
      await oNepaliFolder.create(recursive: true);
      logger.d('Created O Nepali folder at: ${oNepaliFolder.path}');
    }

    return oNepaliFolder;
  }

  // Share file on iOS using the share sheet
  Future<void> _shareFileOnIOS(String filePath, String filename) async {
    if (Platform.isIOS) {
      try {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(filePath)],
            text: 'Downloaded from O Nepali: $filename',
            subject: 'O Nepali Worksheet',
          ),
        );
      } catch (e) {
        logger.e('Error sharing file on iOS: $e');
        showCustomToaster('File saved to app documents', isError: false);
      }
    }
  }

  // Check and request storage permissions based on platform
  Future<bool> _checkStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we need different permissions
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // Try requesting manage external storage permission first
      PermissionStatus status =
          await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        return true;
      }

      // Fallback to regular storage permission for older Android versions
      status = await Permission.storage.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      return true;
    }

    // For other platforms (web, desktop), assume permission is granted
    return true;
  }

  // Download single worksheet using http
  Future<bool> downloadWorksheet(PLesson lesson, String printableTitle) async {
    try {
      // Check storage permission
      if (!await _checkStoragePermission()) {
        final errorMessage =
            Platform.isAndroid
                ? 'Storage permission required to download files'
                : 'Unable to access file storage';
        showCustomToaster(errorMessage, isError: true);
        return false;
      }

      _isDownloading = true;
      _downloadingWorksheetId = lesson.id;
      _downloadProgress = 0.0;
      notifyListeners();

      // Use public Documents folder instead of app documents
      final Directory oNepaliFolder = await _getOrCreateONepaliFolder();

      // Create filename
      final String filename = '${printableTitle}_${lesson.title}.pdf'
          .replaceAll(
            RegExp(r'[^\w\s-.]'),
            '',
          ) // Remove invalid filename characters
          .replaceAll(RegExp(r'\s+'), '_'); // Replace spaces with underscores

      final String filePath = '${oNepaliFolder.path}/$filename';
      final File file = File(filePath);

      // Check if file already exists
      if (await file.exists()) {
        _isDownloading = false;
        _downloadingWorksheetId = '';
        notifyListeners();

        if (Platform.isIOS) {
          showCustomToaster('File already exists: $filename');
          await _shareFileOnIOS(filePath, filename);
        } else {
          showCustomToaster('File already exists: $filename');
        }
        return true;
      }

      // Download the file using http
      final response = await http.get(Uri.parse(lesson.worksheet.pdfUrl));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);

        _isDownloading = false;
        _downloadingWorksheetId = '';
        _downloadProgress = 0.0;
        notifyListeners();

        if (Platform.isIOS) {
          showCustomToaster('Downloaded: $filename');
          await _shareFileOnIOS(filePath, filename);
        } else {
          showCustomToaster('Downloaded: $filename');
        }

        logger.d('Downloaded worksheet: $filePath');
        return true;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      _isDownloading = false;
      _downloadingWorksheetId = '';
      _downloadProgress = 0.0;
      notifyListeners();

      logger.e('Error downloading worksheet: $e');
      showCustomToaster('Failed to download worksheet', isError: true);
      return false;
    }
  }

  // Download all worksheets in a printable
  Future<void> downloadAllWorksheets(PrintableModel printable) async {
    try {
      if (!await _checkStoragePermission()) {
        final errorMessage =
            Platform.isAndroid
                ? 'Storage permission required to download files'
                : 'Unable to access file storage';
        showCustomToaster(errorMessage, isError: true);
        return;
      }

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

      if (successCount == totalCount) {
        if (Platform.isIOS) {
          showCustomToaster(
            'All worksheets downloaded! Files are available in the app and can be shared.',
          );
        } else {
          showCustomToaster('All worksheets downloaded successfully!');
        }
      } else if (successCount > 0) {
        if (Platform.isIOS) {
          showCustomToaster(
            'Downloaded $successCount of $totalCount worksheets. Files available in app.',
          );
        } else {
          showCustomToaster(
            'Downloaded $successCount of $totalCount worksheets',
          );
        }
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
}
