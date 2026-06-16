import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/dialog/create_child_profile_dialog.dart';
import 'package:onepali/src/screen/song/songs_category_grid.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final int selectedTabIndex;
  final Function(int)? onTabChanged;

  const HomeScreen({super.key, this.selectedTabIndex = 0, this.onTabChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedTabIndex;
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  bool _hasHandledInitialNoChildDialog = false;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.selectedTabIndex;
    _checkInitialConnectivity();
    _listenToConnectivityChanges();
  }

  Future<void> _checkInitialConnectivity() async {
    final isConnected = await _connectivityService.isConnected();
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });
    }
  }

  void _listenToConnectivityChanges() {
    _connectivityService.onNetworkTypeChanged.listen((networkType) {
      final isConnected = networkType != NetworkType.none;
      if (mounted && _isConnected != isConnected) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTabIndex != oldWidget.selectedTabIndex) {
      setState(() {
        _selectedTabIndex = widget.selectedTabIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is guest
    bool isGuest = GuestUtil.isGuestUser();
    if (!isGuest) {
      _maybeShowInitialCreateChildDialog();
    }

    // If offline, show single error screen for the current module
    if (!_isConnected) {
      return _buildOfflineError(isGuest);
    }

    // Fetch data for the selected tab only when needed (and not a guest user)
    if (!isGuest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_selectedTabIndex == 0) {
          context.read<RecommendedLessonProvider>().fetchRecommendedLessons();
        } else if (_selectedTabIndex == 1) {
          context.read<RcmSongProvider>().fetchRecommendedSongs();
        } else if (_selectedTabIndex == 2) {
          context.read<RecommendedStoryProvider>().fetchRecommendedStories();
        }
      });
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedTabIndex == 0) ...[
            CourseScreen(),
          ] else if (_selectedTabIndex == 1) ...[
            SongsCategoryGrid(),
          ] else if (_selectedTabIndex == 2) ...[
            StoryScreen(),
          ],
        ],
      ),
    );
  }

  Widget _buildOfflineError(bool isGuest) {
    VoidCallback onRetry;

    switch (_selectedTabIndex) {
      case 0:
        onRetry = () {
          context.read<LessonProvider>().fetchCourses();
          if (!isGuest) {
            context.read<RecommendedLessonProvider>().fetchRecommendedLessons();
          }
        };
        break;
      case 1:
        onRetry = () {
          context.read<SongProvider>().fetchSongs();
          if (!isGuest) {
            context.read<RcmSongProvider>().fetchRecommendedSongs();
          }
        };
        break;
      case 2:
        onRetry = () {
          context.read<StoryProvider>().fetchStories();
          if (!isGuest) {
            context.read<RecommendedStoryProvider>().fetchRecommendedStories();
          }
        };
        break;
      default:
        onRetry = () {};
    }

    return ErrorScreen(
      title: "You're offline",
      message: "Oops, please check your connection to get back online.",
      onRetry: onRetry,
      isInternetError: true,
      isDataError: false,
    );
  }

  void _maybeShowInitialCreateChildDialog() {
    if (_hasHandledInitialNoChildDialog || !mounted) return;

    final childProvider = context.read<ChildUserProvider>();
    if (childProvider.status == DataFetchStatus.loading ||
        childProvider.status == DataFetchStatus.initial) {
      return;
    }

    _hasHandledInitialNoChildDialog = true;
    final hasNoChild = childProvider.totalChildren <= 0;
    if (!hasNoChild) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final shouldCreateChild = await showCreateChildProfileDialog(context);
      if (!mounted) return;
      if (shouldCreateChild == true) {
        Utility.navigate(context, AppRoutes.childRegisterScreen);
      }
    });
  }
}
