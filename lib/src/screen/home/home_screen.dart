import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.selectedTabIndex;
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

  double _getCardHeight(BuildContext context) =>
      AppCardResponsive.getCardHeight(context);

  @override
  Widget build(BuildContext context) {
    // Check if user is guest
    bool isGuest = GuestUtil.isGuestUser();

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
            if (!isGuest) ...[
              _buildRecommendedLessonCard(context),
              Gaps.verticalGapOf(10),
            ],
            _buildLessons(context),
          ] else if (_selectedTabIndex == 1) ...[
            // Only show recommended card for non-guest users
            if (!isGuest) ...[
              _buildRecommendedSongCard(context),
              Gaps.verticalGapOf(10),
            ],
            _buildSongCard(context),
          ] else if (_selectedTabIndex == 2) ...[
            // Only show recommended card for non-guest users
            if (!isGuest) ...[
              _buildRecommendedStoryCard(context),
              Gaps.verticalGapOf(10),
            ],
            _buildStories(context),
          ],
        ],
      ),
    );
  }

  Consumer<RecommendedLessonProvider> _buildRecommendedLessonCard(
    BuildContext context,
  ) {
    return Consumer<RecommendedLessonProvider>(
      builder: (context, provider, child) {
        if (!(provider.hasData)) return const SizedBox();
        return TitleActionChild(
          title: 'Recommended Lessons',
          titlePadding: const EdgeInsets.only(bottom: 8, left: 16),
          titleStyle: AppStyles.text20PxSemiBold.copyWith(
            color: AppColors.kBlack,
          ),

          child: SizedBox(
            height: _getCardHeight(context),
            child: RecommendedLessonsList(),
          ),
        );
      },
    );
  }

  Widget _buildLessons(BuildContext context) {
    return SizedBox(
      height: AppCardResponsive.getLessonCardHeight(context) + 50,
      child: CourseScreen(isMobile: false),
    );
  }

  Widget _buildSongCard(BuildContext context) {
    return TitleActionChild(
      title: 'Songs',
      titlePadding: const EdgeInsets.only(bottom: 8, left: 16),
      titleStyle: AppStyles.text20PxSemiBold.copyWith(color: AppColors.kBlack),
      subTitle: 'VIEW ALL',
      subTitleStyle: AppStyles.text14PxMedium.copyWith(
        color: AppColors.kSecondaryColor,
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
    return Consumer<RcmSongProvider>(
      builder: (context, provider, child) {
        if (!provider.hasData) return const SizedBox();
        return TitleActionChild(
          title: 'Recommended Songs',
          titlePadding: const EdgeInsets.only(bottom: 8, left: 16),
          titleStyle: AppStyles.text20PxSemiBold.copyWith(
            color: AppColors.kBlack,
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
    return Consumer<RecommendedStoryProvider>(
      builder: (context, provider, child) {
        if (!provider.hasData) return const SizedBox();
        return TitleActionChild(
          title: 'Recommended Stories',
          titlePadding: const EdgeInsets.only(bottom: 8, left: 16),
          titleStyle: AppStyles.text20PxSemiBold.copyWith(
            color: AppColors.kBlack,
          ),
          child: SizedBox(
            height: _getCardHeight(context),
            child: RecommendedStoriesList(),
          ),
        );
      },
    );
  }

  Widget _buildStories(BuildContext context) {
    return TitleActionChild(
      title: 'Stories',
      titlePadding: const EdgeInsets.only(bottom: 8, left: 16),
      titleStyle: AppStyles.text20PxSemiBold.copyWith(color: AppColors.kBlack),
      child: SizedBox(height: _getCardHeight(context), child: StoryScreen()),
    );
  }
}
