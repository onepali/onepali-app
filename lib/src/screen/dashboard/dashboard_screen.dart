import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0;
  String childProfileImage = '';
  int totalLessonsCompleted = 0;

  // Moved to provider

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() async {
      final childProvider = context.read<ChildUserProvider>();

      await context.read<UserProvider>().fetchOwnProfile();
      await childProvider.fetchChildUser();
      await childProvider.selectDefaultChildIfNeeded(context);
      await _initializeScreenTimeTracking();

      // Use provider method to get current child
      final currentChild = await childProvider.getCurrentChild();
      setState(() {
        childProfileImage = currentChild?.avatarUrl ?? Assets.avatar1;
        totalLessonsCompleted =
            currentChild?.completedLessons?.totalLessonsCompleted ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _stopScreenTimeTracking();
    super.dispose();
  }

  Future<void> _initializeScreenTimeTracking() async {
    logger.i('🚀 DashboardScreen: Initializing screen time tracking');

    final currentChildId = await ChildLocalStorage.getCurrentChildId();
    if (currentChildId != null) {
      logger.d('👶 Found current child ID: $currentChildId');
      if (!mounted) return;
      final childProvider = context.read<ChildUserProvider>();
      if (childProvider.childUser.isNotEmpty) {
        final childIndex = childProvider.childUser.indexWhere(
          (c) => c.uid == currentChildId,
        );
        final child =
            childIndex != -1
                ? childProvider.childUser[childIndex]
                : childProvider.childUser.first;

        logger.i('👦 Child selected: ${child.fullName} (${child.uid})');

        // Check if the screen time limit is already exceeded
        final isLimitExceeded = await ScreenTimeService.instance
            .checkScreenTimeLimitExceeded(child.uid);

        // If limit is not exceeded, start tracking
        if (!isLimitExceeded) {
          logger.i(
            '🕐 Starting screen time tracking for: ${child.fullName} (${child.uid})',
          );
          await ScreenTimeService.instance.startTracking(child.uid);
        } else {
          logger.w(
            '⚠️ Screen time limit already exceeded for child ${child.uid}',
          );
          // The dialog is already shown by checkScreenTimeLimitExceeded
        }
      } else {
        logger.w('⚠️ No children found in provider');
      }
    } else {
      logger.w('⚠️ No current child ID found');
    }
  }

  Future<void> _stopScreenTimeTracking() async {
    logger.i('🛑 DashboardScreen: Stopping screen time tracking');
    await ScreenTimeService.instance.stopTracking();
  }

  // Check screen time limit on dashboard refresh
  Future<void> _checkScreenTimeLimit() async {
    logger.i('🔄 DashboardScreen: Checking screen time limit on refresh');

    final currentChildId = await ChildLocalStorage.getCurrentChildId();
    if (currentChildId != null && mounted) {
      await ScreenTimeService.instance.checkScreenTimeLimitExceeded(
        currentChildId,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will run when the dependencies change, good place for refresh checks
    _checkScreenTimeLimit();
  }

  @override
  Widget build(BuildContext context) {
    final childProvider = context.read<ChildUserProvider>();
    final userProvider = context.watch<UserProvider>();
    final UserModel? userInfo = userProvider.user;
    final bool isLoading = userProvider.status == DataFetchStatus.loading;
    final bool hasData = userInfo != null;
    final int childCount = childProvider.totalChildren;
    logger.d('DashboardScreen: hasData: $hasData, isLoading: $isLoading');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (index, value) {
        doubleTapTrigger();
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: UserAppBar(
            context: context,
            name: userInfo?.fullName ?? 'User',
            profileImage: childProfileImage,
            totalStars: 0,
            totalLessonsCompleted: totalLessonsCompleted,
            totalChildCount: childCount > 0 ? childCount : 0,
            onTabSelected: (tab) {
              final idx = homeServices.indexWhere((e) => e.name == tab);
              if (idx != -1) {
                setState(() {
                  _selectedTabIndex = idx;
                });
                UserAppBar.setTabIndex(idx);
              }
            },
            childData: childProvider.childUser,
            authType: Utility.getAuthTypeFromUserInfo(
              userInfo?.authProvider ?? AuthProviderType.email.name,
            ),
          ),
          body: HomeScreen(selectedTabIndex: _selectedTabIndex),
        ),
      ),
    );
  }
}
