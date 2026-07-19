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
  bool _isSvgImage(String imageUrl) {
    return Uri.tryParse(imageUrl)?.path.toLowerCase().endsWith('.svg') ??
        imageUrl.toLowerCase().endsWith('.svg');
  }

  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getStoriesStream(
    String levelId,
  ) {
    return FirebaseFirestore.instance
        .collection('stories')
        .where('level_id', isEqualTo: levelId)
        .snapshots();
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
                        final cardWidth =
                            baseCardWidth * (isMobile ? 1.12 : 1.0);
                        final cardHeight =
                            baseCardWidth /
                            AppConstants.contentCardAspectRatio *
                            (isMobile ? 1.05 : 1.0);
                        return StreamBuilder(
                          stream: _getStoriesStream(data[index]['id']),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final stories = snapshot.data!.docs
                                  .where(
                                    (story) =>
                                        kDebugMode ||
                                        story.data()['active'] != false,
                                  )
                                  .toList();
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final storyDoc in stories) ...[
                                      SizedBox(
                                        width: cardWidth,
                                        height: cardHeight,
                                        child: Builder(
                                          builder: (context) {
                                            final storyData = storyDoc.data();
                                            final story = StoryModel.fromJson(
                                              storyData,
                                            );
                                            return ContentCard(
                                              nameEn: story.nameEn,
                                              nameNp: story.nameNp,
                                              image: story.thumbnail,
                                              bgImage:
                                                  storyData['bg_image']
                                                      as String?,
                                              isImageSvg: _isSvgImage(
                                                story.thumbnail,
                                              ),
                                              bgColor:
                                                  storyData['bg_color']
                                                      as String?,
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
