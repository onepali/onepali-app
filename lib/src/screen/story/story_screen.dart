import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? childUid;

  List<Map<String, dynamic>> completedStories = [];

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      getCompletedStories();
    });
  }

  Future<void> getCompletedStories() async {
    try {
      final parentId = FirebaseAuth.instance.currentUser?.uid;
      final childId = await ChildLocalStorage.getCurrentChildId();
      if (parentId == null || childId == null) {
        return;
      }
      final querySnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(parentId)
          .collection(AppConstants.childrenCollection)
          .doc(childId)
          .collection(AppConstants.completedContentCollection)
          .where('content_type', isEqualTo: 'story')
          .get();
      logger.d('Completed stories: ${querySnapshot.docs.length}');
      setState(() {
        completedStories = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      logger.e('Error getting completed stories: $e');
    }
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
                                            final isCompleted = completedStories
                                                .any(
                                                  (s) =>
                                                      story['id'] ==
                                                      s['content_id'],
                                                );
                                            return ContentCard(
                                              nameEn: story['nameEn'],
                                              nameNp: story['nameNp'],
                                              image: story['thumbnail'],
                                              bgImage: story['bg_image'],
                                              isImageSvg: true,
                                              bgColor: story['bg_color'],
                                              isCompleted: isCompleted,
                                              onTap: () {
                                                final storyModel =
                                                    StoryModel.fromJson(
                                                      story.data(),
                                                    );
                                                Utility.navigateMaterialRoute(
                                                  context,
                                                  StoryContentScreen(
                                                    story: storyModel,
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
