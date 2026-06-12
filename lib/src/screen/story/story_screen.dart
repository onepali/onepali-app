import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/src.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  List<Map<String, dynamic>> completedStories = [];

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      getCompletedStories();
    });
  }

  Future<void> getCompletedStories() async {
    final stories = await MetricsTrackingHelper.fetchCompletedContent(
      activityType: ActivityType.story,
    );
    if (!mounted) return;
    setState(() {
      completedStories = stories;
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getStoriesStream(
    String levelId,
  ) {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('stories')
        .where('level_id', isEqualTo: levelId);

    if (!kDebugMode) {
      query = query.where('active', isEqualTo: true);
    }

    return query.snapshots();
  }

  bool _isSvgImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return false;
    final uri = Uri.tryParse(imageUrl);
    final path = uri?.path.toLowerCase() ?? imageUrl.toLowerCase();
    return path.endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    return SafeArea(
      right: true,
      bottom: false,
      top: false,
      left: true,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('story_levels')
            .orderBy('name', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              padding: EdgeInsets.only(left: 24, right: 24),
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
                    SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final baseCardWidth = AppConstants.contentCardGridWidth(
                          constraints.maxWidth,
                          isMobile: isMobile,
                        );
                        final cardWidth = baseCardWidth * (isMobile ? 1.12 : 1.0);
                        final cardHeight =
                            baseCardWidth /
                            AppConstants.contentCardAspectRatio *
                            (isMobile ? 1.05 : 1.0);
                        return StreamBuilder(
                          stream: _getStoriesStream(data[index]['id']),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final stories = snapshot.data!.docs;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final story in stories) ...[
                                      SizedBox(
                                        width: cardWidth,
                                        height: cardHeight,
                                        child: Builder(
                                            builder: (context) {
                                              final storyId = story.id;
                                              final isCompleted =
                                                  completedStories.any(
                                                    (completedStory) =>
                                                        completedStory['content_id'] ==
                                                        storyId,
                                                  );
                                              return ContentCard(
                                                nameEn: story['nameEn'],
                                                nameNp: story['nameNp'],
                                                image: story['thumbnail'],
                                                bgImage: story['bg_image'],
                                                isImageSvg: _isSvgImage(
                                                  story['thumbnail'] as String?,
                                                ),
                                                bgColor: story['bg_color'],
                                                isCompleted: isCompleted,
                                                onTap: () async {
                                                  final storyModel =
                                                      StoryModel.fromJson(
                                                        story.data(),
                                                      );
                                                  await Utility.navigateMaterialRoute(
                                                    context,
                                                    StoryContentScreen(
                                                      story: storyModel,
                                                      isFromRecommended: false,
                                                    ),
                                                  );
                                                  if (!mounted) return;
                                                  await getCompletedStories();
                                                },
                                              );
                                            },
                                          ),
                                      ),
                                      Gaps.horizontalGapOf(
                                        AppConstants.contentCardGridSpacing,
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }
                            return const CircularProgressIndicator();
                          },
                        );
                      },
                    ),
                    SizedBox(height: 24),
                  ],
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
