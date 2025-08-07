import 'package:onepali/src/src.dart';

class AppConstants {
  static const String appName = 'O Nepali';
  static const String appVersion = 'v1.0.0';
  static const String defaultFontFamily = 'Poppins';

  static const String applicationId = 'com.onepali.app';
  static const String dotEnvFileName = '.env';
  static const String defaultLanguageCode = 'en';
  static const String supportMail = 'hello@onepali.fun';

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
  static const String guestLogged = 'guest_logged';

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
  static const String childRewardCollection = 'creward';
  static const String rewardCollection = 'reward_collection';

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

  static const int starBlastDuration = 3000; // Duration in milliseconds

  static List<String> sysTab = ['About us', 'Contact us', 'FAQs'];

  static List<String> whyLearningNepali = [
    'Develop a learning habit',
    'Communicate with relatives in Nepal',
    'Build vocabulary',
    'Daily conversation',
  ];

  /// Screen Time Constants
  // static const String screenTimeExceededKey = 'screen_time_exceeded';
  static const int screenTimeCheckIntervalSeconds =
      10; // Check every 10 seconds
  // static const int dailyResetHour = 23; // Reset at 11:59 PM
  // static const int dailyResetMinute = 59;

  /// Model Route
  static const String datePickerModal = 'date_picker_modal';
  static const String timePickerModal = 'time_picker_modal';
  static const String avatarPickerModal = 'avatar_picker_modal';
  static const String bottomSheetModal = 'bottom_sheet';
  static const String dialogModal = 'dialog';
  static const String modalRoute = 'modal';
  static const String customDialogModal = 'custom_dialog';

  /// Lesson Video Cache DB
  static const String lessonVideoCacheDB = 'lesson_videos';
  static const int lessonVideoCacheDays = 7;
  static const int lessonVideoCacheMaxObjects = 50;

  /// Reward Outlined Stickers
  static List<String> rewardOutlinedStickers = [
    'https://firebasestorage.googleapis.com/v0/b/o-nepali.firebasestorage.app/o/reward%2Fsnow_leopard_outline.svg?alt=media&token=499f6b1d-da05-45b1-8ca4-5eaad0311546',
    'https://firebasestorage.googleapis.com/v0/b/o-nepali.firebasestorage.app/o/reward%2Fred_panda_outline.svg?alt=media&token=e8e7b4ed-c0d7-442d-9459-7f1e2682c2c6',
    'https://firebasestorage.googleapis.com/v0/b/o-nepali.firebasestorage.app/o/reward%2Fdanfe_outline.svg?alt=media&token=c70f3622-ae3e-4513-b137-8fe584c56249',
  ];

  static List<Map<String, dynamic>> languages = [
    {'code': 'en', 'name': 'English', 'flag': 'assets/images/flags/en.png'},
    {'code': 'ne', 'name': 'नेपाली', 'flag': 'assets/images/flags/ne.png'},
  ];

  /// Extend [Time] Map
  static Map<String, int> extendTimeMap = {
    '5 mins': 5,
    '10 mins': 10,
    '15 mins': 15,
    '20 mins': 20,
  };

  // Notification Titles & Bodies [Daily Reminder]
  static const String dailyReminderTitle = "⏰ It's Time to Practice!";
  static const String dailyReminderBody =
      "Let's make today awesome! Are you ready for your daily adventure? 🚀";

  static const String kAppLink =
      'https://play.google.com/store/apps/details?id=$applicationId';
}
