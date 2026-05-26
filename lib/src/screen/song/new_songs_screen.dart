import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/src.dart';

class NewSongsScreen extends StatefulWidget {
  final String categoryId;
  final String title;
  const NewSongsScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  State<NewSongsScreen> createState() => _NewSongsScreenState();
}

class _NewSongsScreenState extends State<NewSongsScreen> {
  List<Map<String, dynamic>> completedSongs = [];

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      getCompletedSongs();
    });
  }

  Future<void> getCompletedSongs() async {
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
          .where('content_type', isEqualTo: 'song')
          .get();
      logger.d('Completed songs: ${querySnapshot.docs.length}');
      setState(() {
        completedSongs = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      logger.e('Error getting completed songs: $e');
    }
  }

  Widget _buildTitleText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: 36,
        letterSpacing: 1,
        fontWeight: FontWeight.bold,
        color: AppColors.kDrawerBgColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);

    return Scaffold(
      body: SafeArea(
        right: true,
        bottom: false,
        top: false,
        left: true,
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: isMobile
                            ? closeBtnPositionMobile
                            : closeBtnPositionTablet,
                        bottom: isMobile
                            ? closeBtnPositionMobile
                            : closeBtnPositionTablet,
                        right: isMobile
                            ? closeBtnPositionMobile
                            : closeBtnPositionTablet,
                      ),
                      child: CustomCloseButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(child: _buildTitleText(context, widget.title)),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('songs')
                    .where('category_id', isEqualTo: widget.categoryId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!.docs;
                    return GridView.builder(
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 2.0,
                        mainAxisSpacing: 24.0,
                        crossAxisSpacing: 24.0,
                      ),
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs;
                        final song = SongModel.fromJson(data[index].data());
                        final isCompleted = completedSongs.any(
                          (s) => song.id == s['content_id'],
                        );
                        return ContentCard(
                          showPlay: true,
                          isCompleted: isCompleted,
                          nameEn: song.titleEn,
                          nameNp: song.titleNe,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SongVideoPlayerScreen(
                                  youtubeUrl:
                                      data[index]['media']['youtube_link'],
                                  title: data[index]['title_en'],
                                  subtitle: '',
                                  isLocked: false,
                                  info: '',
                                  songId: data[index].id,
                                  initialPosition: 0.0,
                                  image: Utility.generateYoutubeThumbnailUrl(
                                    data[index]['media']['youtube_link'],
                                  ),
                                ),
                              ),
                            );
                          },
                          image: null,
                          bgImage: Utility.generateYoutubeThumbnailUrl(
                            song.media.youtubeLink,
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
