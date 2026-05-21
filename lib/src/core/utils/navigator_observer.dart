import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onepali/src/src.dart';

class OrientationRouteObserver extends NavigatorObserver {
  /// Routes that should lock to PORTRAIT (parent-facing screens)
  /// This list is used to determine orientation for both named routes and initial route
  static const List<String> portraitRoutes = [
    // Auth & Onboarding
    AppRoutes.splashScreen,
    AppRoutes.onboardingScreen,
    AppRoutes.loginScreen,
    AppRoutes.registerScreen,
    AppRoutes.rs1Screen,
    AppRoutes.rs2Screen,
    AppRoutes.rs3Screen,
    AppRoutes.rs4Screen,
    AppRoutes.rs5Screen,
    AppRoutes.rs6Screen,

    // Child Registration (parent registers child - child profile creation)
    AppRoutes.childRegisterScreen,
    AppRoutes.childRS1Screen,
    AppRoutes.childRS2Screen,
    AppRoutes.childRS3Screen,
    AppRoutes
        .childRS4Screen, // Receive updates prompt - part of child profile creation
    AppRoutes.extendTimeScreen,

    // Parent Zone (all parent-facing screens)
    AppRoutes.parentDashboardScreen,
    // AppRoutes.parentPinScreen, // Passcode screen can be landscape
    AppRoutes.parentHomeScreen,
    AppRoutes.parentSettingScreen,
    AppRoutes.parentBlogScreen,
    AppRoutes.blogDetailScreen,
    AppRoutes.parentReviewScreen,
    AppRoutes.parentNotificationScreen,
    AppRoutes.parentPlansScreen,

    // System & Info
    AppRoutes.systemScreen,
    AppRoutes.aboutUsScreen,
    AppRoutes.contactScreen,
    AppRoutes.faqsScreen,

    // Profile & Printables (parent-facing)
    AppRoutes.parentProfileScreen,
    AppRoutes.childProfileScreen, // Parent updates child profile
    AppRoutes.printableScreen, // Parent-facing printables
  ];

  /// Check if a route should be portrait based on route name or widget type
  bool _shouldBePortrait(Route<dynamic>? route) {
    if (route == null) return false;

    final name = route.settings.name ?? '';

    logger.d(
      '🔍 Checking orientation for route: name="$name", '
      'type=${route.runtimeType}, '
      'settings=${route.settings.runtimeType}',
    );

    // Check by route name first (works for both named routes and MaterialRoute with routeName)
    if (name.isNotEmpty) {
      final isPortrait = portraitRoutes.contains(name);
      if (isPortrait) {
        logger.d('✅ Route "$name" is in portraitRoutes list');
        return true;
      } else {
        logger.d(
          '❌ Route "$name" is NOT in portraitRoutes list (defaulting to landscape)',
        );
      }
    } else {
      logger.w(
        '⚠️ Route has no name, cannot determine orientation from route name',
      );
    }

    // For MaterialRoute navigations without routeName, check widget type
    // This is a fallback for routes navigated via navigateMaterialRoute without routeName
    if (route is MaterialPageRoute) {
      // Try to infer orientation from widget type
      // Most child-facing screens (CourseScreen, LessonScreen, StoryScreen, etc.)
      // are navigated via MaterialRoute and should be landscape
      // Parent-facing screens typically use named routes
      logger.d('📱 MaterialPageRoute detected, defaulting to landscape');
    }

    // Default to landscape for child-facing screens
    // (Course, Lesson, Story, Song, Achievement screens are all landscape)
    return false;
  }

  /// Set orientation with platform-specific handling
  Future<void> _setOrientation(
    Route<dynamic>? route,
    BuildContext? context, {
    Route<dynamic>? previousRoute,
  }) async {
    // Skip orientation changes for popup menu and dialog routes - they're just overlays
    final name = route?.settings.name ?? '';
    if (name == AppConstants.popupMenuModal ||
        name == AppConstants.customDialogModal) {
      logger.d('🚫 Skipping orientation change for overlay route: $name');
      return;
    }

    // Passcode screen should maintain previous route's orientation (no rotation)
    if (name == AppRoutes.parentPinScreen) {
      logger.d(
        '🚫 Skipping orientation change for passcode screen (maintaining previous orientation)',
      );
      return;
    }

    // Drawer routes (family menu) should always be landscape
    if (name == AppRoutes.drawerRoutes || name == AppRoutes.tabDrawerRoutes) {
      logger.d('🔄 Setting drawer route to landscape');
      final isTablet = context != null && PlatformUtility.isTablet(context);
      final isIOS = context != null && PlatformUtility.isIOS(context);
      final useAllowAllPattern = isIOS || isTablet;

      // Determine which landscape orientation to prefer for 90° rotation
      DeviceOrientation preferredLandscape = DeviceOrientation.landscapeRight;
      if (context != null) {
        final currentOrientation = MediaQuery.of(context).orientation;
        // If coming from portrait, prefer landscapeRight (90° clockwise from portraitUp)
        // This ensures 90° rotation instead of 270°
        if (currentOrientation == Orientation.portrait) {
          preferredLandscape = DeviceOrientation.landscapeRight;
        }
      }

      if (useAllowAllPattern) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
        ]);
        await Future.delayed(const Duration(milliseconds: 100));
        // Set preferred landscape first to influence rotation direction
        await SystemChrome.setPreferredOrientations([preferredLandscape]);
        await Future.delayed(const Duration(milliseconds: 50));
        // Then allow both landscape orientations
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
        await Future.delayed(const Duration(milliseconds: 50));
      } else {
        // For Android, set preferred first, then both
        await SystemChrome.setPreferredOrientations([preferredLandscape]);
        await Future.delayed(const Duration(milliseconds: 50));
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
      }
      return;
    }

    final shouldBePortrait = _shouldBePortrait(route);

    // Check if previous route also required the same orientation
    // If so, skip orientation change to avoid flickering
    // BUT: Always allow orientation change when navigating to/from dashboard or drawer
    // (dashboard is landscape, drawer is landscape, parent zone is portrait)
    final isNavigatingToDashboard = name == AppRoutes.dashboardScreen;
    final isNavigatingFromDashboard =
        previousRoute != null &&
        (previousRoute.settings.name == AppRoutes.dashboardScreen);
    final isNavigatingToDrawer =
        name == AppRoutes.drawerRoutes || name == AppRoutes.tabDrawerRoutes;
    final isNavigatingFromDrawer =
        previousRoute != null &&
        (previousRoute.settings.name == AppRoutes.drawerRoutes ||
            previousRoute.settings.name == AppRoutes.tabDrawerRoutes);

    if (previousRoute != null &&
        !isNavigatingToDashboard &&
        !isNavigatingFromDashboard &&
        !isNavigatingToDrawer &&
        !isNavigatingFromDrawer) {
      final previousShouldBePortrait = _shouldBePortrait(previousRoute);
      if (previousShouldBePortrait == shouldBePortrait) {
        logger.d(
          '🚫 Skipping orientation change: route "$name" requires same orientation '
          '(${shouldBePortrait ? "PORTRAIT" : "LANDSCAPE"}) as previous route',
        );
        return;
      }
    }

    // Log when navigating to/from dashboard to ensure orientation change happens
    if (isNavigatingToDashboard || isNavigatingFromDashboard) {
      logger.d(
        '🔄 Navigating ${isNavigatingToDashboard ? "TO" : "FROM"} dashboard - '
        'will change orientation to ${shouldBePortrait ? "PORTRAIT" : "LANDSCAPE"}',
      );
    }
    final isTablet = context != null && PlatformUtility.isTablet(context);
    final isIOS = context != null && PlatformUtility.isIOS(context);

    // Use "allow all then lock" pattern for iOS and tablets (more reliable)
    final useAllowAllPattern = isIOS || isTablet;

    // Check if we're actually changing orientation
    bool isChangingOrientation = false;
    if (context != null) {
      final currentOrientation = MediaQuery.of(context).orientation;
      isChangingOrientation =
          (shouldBePortrait && currentOrientation == Orientation.landscape) ||
          (!shouldBePortrait && currentOrientation == Orientation.portrait);
    }

    // If not changing orientation, skip the orientation change
    if (!isChangingOrientation) {
      logger.d(
        '🚫 Skipping orientation change: already in correct orientation',
      );
      return;
    }

    // For tablets/iOS, use "allow all then lock" pattern for reliability
    // This pattern is required for iPads to respect orientation locking
    // For Android phones, set directly to avoid multiple rotations
    try {
      if (useAllowAllPattern) {
        // Step 1: Allow all orientations briefly (required for tablets)
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
        ]);

        // Step 2: Wait for system to register the change (critical for tablets)
        await Future.delayed(const Duration(milliseconds: 200));

        // Step 3: Lock to target orientation
        if (shouldBePortrait) {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        } else {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
          ]);
        }

        // Step 4: Additional delay for tablets/iOS to ensure lock is applied
        await Future.delayed(const Duration(milliseconds: 150));
      } else {
        // Direct locking for Android phones (works reliably without pattern)
        if (shouldBePortrait) {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        } else {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
          ]);
        }
      }
    } catch (e) {
      // Log error but don't throw - orientation changes may fail on simulators
      // or in certain windowing modes, but the app should continue to function
      logger.w(
        '⚠️ Failed to set orientation (may be expected on simulator/windowed mode): $e',
      );
    }

    logger.d(
      '🔒 Orientation locked: ${shouldBePortrait ? "PORTRAIT" : "LANDSCAPE"} '
      'for route: ${route?.settings.name ?? "unknown"} '
      '(Platform: ${isIOS ? "iOS" : "Android"}, '
      'Device: ${isTablet ? "Tablet" : "Mobile"})',
    );
  }

  /// Set orientation when popping drawer route (async helper)
  Future<void> _setOrientationForDrawerPop(
    Route<dynamic>? previousRoute,
    BuildContext? context,
    bool shouldBePortrait,
  ) async {
    final isTablet = context != null && PlatformUtility.isTablet(context);
    final isIOS = context != null && PlatformUtility.isIOS(context);
    final useAllowAllPattern = isIOS || isTablet;

    if (useAllowAllPattern) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeRight,
      ]);
      await Future.delayed(const Duration(milliseconds: 100));
      if (shouldBePortrait) {
        // Prefer portraitUp for 90° counterclockwise from landscapeRight
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        await Future.delayed(const Duration(milliseconds: 50));
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        // Prefer landscapeRight for 90° clockwise from portraitUp
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
        await Future.delayed(const Duration(milliseconds: 50));
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
      }
      await Future.delayed(const Duration(milliseconds: 50));
    } else {
      if (shouldBePortrait) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        await Future.delayed(const Duration(milliseconds: 50));
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
        await Future.delayed(const Duration(milliseconds: 50));
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
      }
    }
  }

  /// Get context from navigator if available
  BuildContext? _getContext(Route<dynamic>? route) {
    try {
      // Try to get context from navigator
      final navigator = route?.navigator;
      if (navigator != null) {
        return navigator.context;
      }
    } catch (e) {
      logger.w('Could not get context from route: $e');
    }
    return null;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = route.settings.name ?? '';

    // Skip orientation changes for popup menu, dialogs, and unnamed overlays (like dropdowns)
    if (routeName == AppConstants.popupMenuModal ||
        routeName == AppConstants.customDialogModal ||
        routeName.isEmpty) {
      logger.d(
        '🚫 Skipping orientation change when pushing overlay route: ${routeName.isEmpty ? "unnamed overlay" : routeName}',
      );
      super.didPush(route, previousRoute);
      return;
    }

    // Drawer routes should always be landscape - handle them explicitly
    if (routeName == AppRoutes.drawerRoutes ||
        routeName == AppRoutes.tabDrawerRoutes) {
      logger.d('🔄 Drawer route detected in didPush: $routeName');

      // Check if we're coming from a landscape route (dashboard)
      // If so, skip orientation change to avoid unnecessary rotation
      if (previousRoute != null) {
        final previousShouldBePortrait = _shouldBePortrait(previousRoute);
        if (!previousShouldBePortrait) {
          logger.d(
            '🚫 Skipping orientation change: drawer and previous route (dashboard) are both landscape',
          );
          super.didPush(route, previousRoute);
          return;
        }
      }

      // Only set landscape if coming from portrait (Parent Zone)
      logger.d('🔄 Setting drawer to landscape (coming from portrait route)');
      final context = _getContext(route);
      _setOrientation(route, context, previousRoute: previousRoute);
      super.didPush(route, previousRoute);
      return;
    }

    final context = _getContext(route);
    _setOrientation(route, context, previousRoute: previousRoute);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final poppedRouteName = route.settings.name ?? '';

    // Skip orientation changes for popup menu, dialogs, and unnamed overlays (dropdowns)
    if (poppedRouteName == AppConstants.popupMenuModal ||
        poppedRouteName == AppConstants.customDialogModal ||
        poppedRouteName.isEmpty) {
      logger.d(
        '🚫 Skipping orientation change when popping overlay route: ${poppedRouteName.isEmpty ? "unnamed overlay" : poppedRouteName}',
      );
      super.didPop(route, previousRoute);
      return;
    }

    // Skip orientation changes when popping passcode screen - it maintains previous orientation
    if (poppedRouteName == AppRoutes.parentPinScreen) {
      logger.d(
        '🚫 Skipping orientation change when popping passcode screen (maintaining previous orientation)',
      );
      super.didPop(route, previousRoute);
      return;
    }

    // When popping drawer routes, check where we're going back to
    // If going back to Parent Zone (portrait), set portrait
    // If going back to Dashboard (landscape), skip rotation (both are landscape)
    if (poppedRouteName == AppRoutes.drawerRoutes ||
        poppedRouteName == AppRoutes.tabDrawerRoutes) {
      logger.d(
        '🔄 Popping drawer route: $poppedRouteName, previous route: ${previousRoute?.settings.name ?? "unknown"}',
      );
      if (previousRoute != null) {
        final previousRouteName = previousRoute.settings.name ?? '';
        final previousShouldBePortrait = _shouldBePortrait(previousRoute);
        logger.d(
          '🔄 Previous route "$previousRouteName" should be ${previousShouldBePortrait ? "PORTRAIT" : "LANDSCAPE"}',
        );

        // Drawer is always landscape, so if previous route is also landscape (dashboard),
        // skip orientation change to avoid unnecessary rotation
        if (!previousShouldBePortrait) {
          logger.d(
            '🚫 Skipping orientation change: drawer and dashboard are both landscape',
          );
          super.didPop(route, previousRoute);
          return;
        }

        // Only set orientation if going back to portrait (Parent Zone)
        final context = _getContext(previousRoute);
        _setOrientationForDrawerPop(
          previousRoute,
          context,
          previousShouldBePortrait,
        );
        logger.d(
          '✅ Orientation set to PORTRAIT after popping drawer (returning to Parent Zone)',
        );
      }
      super.didPop(route, previousRoute);
      return;
    }

    // If previous route requires same orientation as what we're already on, skip
    // This prevents unnecessary rotation animations
    if (previousRoute != null) {
      final previousShouldBePortrait = _shouldBePortrait(previousRoute);
      // Check if we're already in the correct orientation by checking current route
      // If previous route needs same orientation, no need to change
      final context = _getContext(previousRoute);
      if (context != null) {
        final currentOrientation = MediaQuery.of(context).orientation;
        final isCurrentlyPortrait = currentOrientation == Orientation.portrait;
        if (previousShouldBePortrait == isCurrentlyPortrait) {
          logger.d(
            '🚫 Skipping orientation change: already in correct orientation '
            '(${isCurrentlyPortrait ? "PORTRAIT" : "LANDSCAPE"}) for route: ${previousRoute.settings.name}',
          );
          super.didPop(route, previousRoute);
          return;
        }
      }
    }

    final context = _getContext(previousRoute);
    _setOrientation(previousRoute, context, previousRoute: route);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final context = _getContext(newRoute);
    _setOrientation(newRoute, context, previousRoute: oldRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final context = _getContext(previousRoute);
    _setOrientation(previousRoute, context, previousRoute: route);
    super.didRemove(route, previousRoute);
  }
}
