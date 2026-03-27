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
  bool _isSvgImage(String imageUrl) {
    return Uri.tryParse(imageUrl)?.path.toLowerCase().endsWith('.svg') ??
        imageUrl.toLowerCase().endsWith('.svg');
  }

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
                          final stories = snapshot.data!.docs;
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: stories.length,
                            separatorBuilder: (_, _) =>
                                Gaps.horizontalGapOf(16),
                            itemBuilder: (context, storyIndex) {
                              final storyDoc = stories[storyIndex];
                              final storyData = storyDoc.data();
                              final story = StoryModel.fromJson(storyData);
                              return ContentCard(
                                nameEn: story.nameEn,
                                nameNp: story.nameNp,
                                image: story.thumbnail,
                                bgImage: storyData['bg_image'] as String?,
                                isImageSvg: _isSvgImage(story.thumbnail),
                                bgColor: storyData['bg_color'] as String?,
                                onTap: () {
                                  Utility.navigateMaterialRoute(
                                    context,
                                    StoryContentScreen(
                                      story: story,
                                      isFromRecommended: false,
                                    ),
                                  );
                                },
                              );
                            },
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
  }
}
