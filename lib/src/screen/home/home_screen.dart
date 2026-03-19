import 'package:flutter/material.dart';
import 'package:onepali/src/screen/song/songs_category_grid.dart';
import 'package:onepali/src/src.dart';
import 'package:onepali/src/screen/course/lesson/widget/recommended_lessons_list.dart';
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

  double _getCardHeight(BuildContext context) {
    return AppCardResponsive.getDashboardCardHeight(context);
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is guest
    bool isGuest = GuestUtil.isGuestUser();

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
          // Gaps.verticalGapOf(10),
          if (_selectedTabIndex == 0) ...[
            // Only show recommended card for non-guest users
            // if (!isGuest) ...[
            //   _buildRecommendedLessonCard(context),
            //   Gaps.verticalGapOf(10),
            // ],
            // _buildLessons(context),
            CourseScreen(),
          ] else if (_selectedTabIndex == 1) ...[
            // Only show recommended card for non-guest users
            // if (!isGuest) ...[
            //   _buildRecommendedSongCard(context),
            //   Gaps.verticalGapOf(10),
            // ],
            // _buildSongCard(context),
            SongsCategoryGrid(),
          ] else if (_selectedTabIndex == 2) ...[
            // Only show recommended card for non-guest users
            // if (!isGuest) ...[
            //   _buildRecommendedStoryCard(context),
            //   Gaps.verticalGapOf(10),
            // ],
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

  Consumer<RecommendedLessonProvider> _buildRecommendedLessonCard(
    BuildContext context,
  ) {
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    bool isMobileLandscape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);
    return Consumer<RecommendedLessonProvider>(
      builder: (context, provider, child) {
        if (!(provider.hasData)) return const SizedBox();
        return TitleActionChild(
          title: 'Recommended lessons',
          titlePadding: EdgeInsets.only(
            bottom: isTabletLandscape ? 21 : 8,
            left: isTabletLandscape ? 24 : (isMobileLandscape ? 20 : 16),
          ),
          titleStyle: AppStyles.text20PxSemiBold.copyWith(
            color: AppColors.kBlack,
            fontSize: isTabletLandscape ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),

          child: SizedBox(
            height: _getCardHeight(context),
            child: RecommendedLessonsList(),
          ),
        );
      },
    );
  }

  Widget _buildSongCard(BuildContext context) {
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    bool isMobileLandscape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);
    return TitleActionChild(
      title: 'Songs',
      titlePadding: EdgeInsets.only(
        bottom: isTabletLandscape ? 21 : 8,
        left: isTabletLandscape ? 24 : (isMobileLandscape ? 20 : 16),
      ),
      titleStyle: AppStyles.text20PxSemiBold.copyWith(
        color: AppColors.kBlack,
        fontSize:
            PlatformUtility.isTablet(context) &&
                PlatformUtility.isLandscape(context)
            ? 24
            : 20,
        fontWeight: FontWeight.bold,
      ),
      subTitle: 'View all',
      subTitleStyle: AppStyles.text14PxMedium.copyWith(
        color: AppColors.kSecondaryColor,
        fontWeight: FontWeight.w500,
        fontSize:
            PlatformUtility.isTablet(context) &&
                PlatformUtility.isLandscape(context)
            ? 18
            : 14,
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SongScreen(showCategoryList: true)),
        );
      },
      child: SizedBox(height: _getCardHeight(context), child: SongScreen()),
    );
  }

  Widget _buildRecommendedSongCard(BuildContext context) {
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    bool isMobileLandscape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);
    return Consumer<RcmSongProvider>(
      builder: (context, provider, child) {
        if (!provider.hasData) return const SizedBox();
        return TitleActionChild(
          title: 'Recommended songs',
          titlePadding: EdgeInsets.only(
            bottom: isTabletLandscape ? 21 : 8,
            left: isTabletLandscape ? 24 : (isMobileLandscape ? 20 : 16),
          ),
          titleStyle: AppStyles.text20PxSemiBold.copyWith(
            color: AppColors.kBlack,
            fontSize: isTabletLandscape ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
          child: SizedBox(
            height: _getCardHeight(context),
            child: RecommendedSongScreen(),
          ),
        );
      },
    );
  }

  Widget _buildRecommendedStoryCard(BuildContext context) {
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    bool isMobileLandscape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);

    return Consumer<RecommendedStoryProvider>(
      builder: (context, provider, child) {
        if (!provider.hasData) return const SizedBox();
        return TitleActionChild(
          title: 'Recommended stories',
          titlePadding: EdgeInsets.only(
            bottom: isTabletLandscape ? 21 : 8,
            left: isTabletLandscape ? 24 : (isMobileLandscape ? 20 : 16),
          ),
          titleStyle: AppStyles.text20PxSemiBold.copyWith(
            color: AppColors.kBlack,
            fontSize: isTabletLandscape ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
          child: SizedBox(
            height: _getCardHeight(context),
            child: RecommendedStoriesList(),
          ),
        );
      },
    );
  }
}
