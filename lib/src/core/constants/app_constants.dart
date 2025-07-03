import 'package:onepali/src/src.dart';

class AppConstants {
  static const String appName = 'O Nepali';
  static const String appVersion = 'v1.0.0';
  static const String defaultFontFamily = 'Poppins';

  static const String applicationId = 'com.onepali.app';
  static const String dotEnvFileName = '.env';
  static const String defaultLanguageCode = 'en';

  // Login Types
  static const String email = 'email';
  static const String google = 'google';
  static const String facebook = 'facebook';

  // Shared Preferences Keys
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userInfo = 'user_info';
  static const String logged = 'logged';
  static const String childIdKey = 'current_child_id';
  static const String avatarUrlKey = 'avatar_url';
  static const String parentDashboardLogged = 'parent_dashboard_logged';

  /// Firebase Collection Names
  static const String usersCollection = 'users';
  static const String childrenCollection = 'children';
  static const String lessonsCollection = 'lessons';
  static const String coursesCollection = 'courses';
  static const String storiesCollection = 'stories';
  static const String songsCollection = 'songs';
  static const String recomStoryCollection = 'recom_story';
  static const String recomSongCollection = 'recom_song';
  static const String recomLessonCollection = 'recom_lesson';

  // Database
  static const String RECOM_DB_PATH = 'onp_recom.db';

  static List<String> get avatarList => [
    Assets.avatar1,
    Assets.avatar2,
    Assets.avatar3,
    Assets.avatar4,
    Assets.avatar5,
    Assets.avatar6,
    Assets.avatar7,
    Assets.avatar8,
  ];

  static List<String> sysTab = ['About Us', 'Contact Us', 'FAQs'];

  static List<String> whyLearningNepali = [
    'Develop a learning habit',
    'Communicate with relatives in Nepal',
    'Build vocabulary',
    'Daily conversation',
  ];

  /// Model Route
  static const String datePickerModal = 'date_picker_modal';
  static const String timePickerModal = 'time_picker_modal';
  static const String avatarPickerModal = 'avatar_picker_modal';
  static const String bottomSheetModal = 'bottom_sheet';
  static const String dialogModal = 'dialog';
  static const String modalRoute = 'modal';

  static List<Map<String, dynamic>> languages = [
    {'code': 'en', 'name': 'English', 'flag': 'assets/images/flags/en.png'},
    {'code': 'ne', 'name': 'नेपाली', 'flag': 'assets/images/flags/ne.png'},
  ];

  // Notification Titles & Bodies [Daily Reminder]
  static const String dailyReminderTitle = "⏰ It's Time to Practice!";
  static const String dailyReminderBody =
      "Let's make today awesome! Are you ready for your daily adventure? 🚀";

  static const String kAppLink =
      'https://play.google.com/store/apps/details?id=$applicationId';
}
