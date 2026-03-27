import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<StoryProvider>().fetchStories();
      context.read<StoryProvider>().fetchRecommendedStoriesForActiveChild(
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('story_levels')
          .orderBy('name', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            padding: EdgeInsets.symmetric(horizontal: 24),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data[index]['name'],
                    style: AppStyles.text20PxSemiBold.copyWith(
                      color: AppColors.kBlack,
                      fontSize: isTabletLandscape ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: isMobile
                        ? MediaQuery.of(context).size.height * 0.45
                        : MediaQuery.of(context).size.height * 0.3,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('stories')
                          .where('level_id', isEqualTo: data[index]['id'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!.docs;
                          return Row(
                            children: [
                              for (final lesson in data) ...[
                                ContentCard(
                                  nameEn: lesson['nameEn'],
                                  nameNp: lesson['nameNp'],
                                  image: lesson['thumbnail'],
                                  bgImage: lesson['bg_image'],
                                  isImageSvg: true,
                                  bgColor: lesson['bg_color'],
                                  onTap: () {
                                    final story = StoryModel.fromJson(
                                      lesson.data(),
                                    );
                                    Utility.navigateMaterialRoute(
                                      context,
                                      StoryContentScreen(
                                        story: story,
                                        isFromRecommended: false,
                                      ),
                                    );
                                  },
                                ),
                                Gaps.horizontalGapOf(16),
                              ],
                            ],
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              );
            },
          );
        }
        return SizedBox();
      },
    );
    return Consumer<StoryProvider>(
      builder: (context, provider, _) {
        return StatusHandler(
          status: provider.status,
          hasData: provider.stories.isNotEmpty,
          errorTitle: 'No stories found',
          errorMessage: 'Please check back later for new stories.',
          checkConnectivity: false,
          onRetry: () {
            context.read<StoryProvider>().fetchStories();
          },
          successBuilder: () {
            final stories = provider.stories;
            // double cardHeight = AppCardResponsive.getDashboardCardHeight(context);

            return SizedBox(
              height: isMobile
                  ? MediaQuery.of(context).size.height * 0.45
                  : MediaQuery.of(context).size.height * 0.3,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: stories.length,
                separatorBuilder: (_, _) => Gaps.horizontalGapOf(16),
                itemBuilder: (context, i) {
                  final story = stories[i];
                  return ContentCard(
                    nameEn: story.nameEn,
                    nameNp: story.nameNp,
                    image: story.thumbnail,
                    isImageSvg: true,
                    bgColor: '#FFC107',
                    onTap: () {},
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
