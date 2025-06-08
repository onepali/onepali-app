import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Gaps.verticalGapOf(10),
          if (_selectedTabIndex == 0)
            _buildLessons(context)
          else if (_selectedTabIndex == 1) ...[
            _buildRecommendedSongCard(context),
            Gaps.verticalGapOf(10),
            _buildSongCard(context),
          ] else if (_selectedTabIndex == 2)
            _buildStories(context),
        ],
      ),
    );
  }

  Widget _buildLessons(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.60,
      child: CourseScreen(),
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
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: SongScreen(),
      ),
    );
  }

  Widget _buildRecommendedSongCard(BuildContext context) {
    return TitleActionChild(
      title: 'Recommended Songs',
      titlePadding: const EdgeInsets.only(bottom: 8, left: 16),
      titleStyle: AppStyles.text20PxSemiBold.copyWith(color: AppColors.kBlack),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: RecommendedSongScreen(),
      ),
    );
  }

  Widget _buildStories(BuildContext context) {
    return TitleActionChild(
      title: 'Stories',
      titlePadding: const EdgeInsets.only(bottom: 8, left: 16),
      titleStyle: AppStyles.text20PxSemiBold.copyWith(color: AppColors.kBlack),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Center(child: Text('Stories Content Here')),
      ),
    );
  }
}
