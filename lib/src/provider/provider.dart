//* ------------------------------- Global Provider ------------------------------- *//

library;

/// [System] Provider
export 'system/system_provider.dart';
export 'system/splash_provider.dart';
export 'system/language_provider.dart';

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

//* ------------------------------- Child Provider ------------------------------- *//

/// [Song] Provider
export 'song/song_provider.dart';

/// [Recommended] Provider
export 'recommended/recommended_song_provider.dart';
export 'recommended/recommended_story_provider.dart';

/// [Story] Provider
export 'story/story_provider.dart';
