//* ------------------------------- Global Provider ------------------------------- *//

library;

/// [System] Provider
export 'system/system_provider.dart';
export 'system/splash_provider.dart';
export 'system/language_provider.dart';
export 'audio_provider.dart';

/// [Auth] Provider
export 'auth/auth_provider.dart'; // Email & Password
export 'auth/fauth_provider.dart'; // Facebook
export 'auth/gauth_provider.dart'; // Google
export 'auth/auth_state.dart'; // Auth State
export 'auth/child_auth_provider.dart'; // Child Auth

/// [User] Provider
export 'user/user_provider.dart';

/// [Lesson] Provider
export 'lesson/lesson_provider.dart';
export 'lesson/laudio_provider.dart';

/// [Child] Provider
export 'child/cuser_provider.dart';

/// [Reward] Provider
export 'reward/reward_provider.dart';

//* ------------------------------- Child Provider ------------------------------- *//

/// [Song] Provider
export 'song/song_provider.dart';

/// [Recommended] Provider
export 'recommended/recommended_song_provider.dart';
export 'recommended/recommended_story_provider.dart';
export 'recommended/recommended_lesson_provider.dart';

/// [Story] Provider
export 'story/story_provider.dart';

//* ------------------------------- PZone Provider ------------------------------- *//

/// PZ [Home] Provider
export 'pzone/pz_home/pz_home_provider.dart';
export 'pzone/pz_home/pz_metrics_provider.dart';

/// PZ [Blog] Provider
export 'pzone/pz_blog/pz_blog_provider.dart';

/// PZ [Notification] Provider
export 'pzone/pz_notification/pz_notification_provider.dart';

/// PZ [Plan] Provider
export 'pzone/pz_plan/pz_plan_provider.dart';

/// PZ [Review] Provider
export 'pzone/pz_review/pz_review_provider.dart';

/// [Guest] Provider
export 'guest/guest_provider.dart';
