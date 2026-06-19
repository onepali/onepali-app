import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/src.dart';

class NewSongsScreen extends StatelessWidget {
  final String categoryId;
  final String title;
  const NewSongsScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  Widget _buildTitleText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontFamily: GoogleFonts.luckiestGuy().fontFamily,
        fontSize: 36,
        letterSpacing: 2,
        fontWeight: FontWeight.bold,
        color: AppColors.kDrawerBgColor,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: isMobile
                        ? closeBtnPositionMobile
                        : closeBtnPositionTablet,
                    right:
                        (isMobile
                            ? closeBtnPositionMobile
                            : closeBtnPositionTablet) +
                        56,
                  ),
                  child: Center(child: _buildTitleText(context, title)),
                ),
              ),
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
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('songs')
                  .where('category_id', isEqualTo: categoryId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;
                  return GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 2.0,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                    ),
                    padding: const EdgeInsets.only(
                      right: 24,
                      left: 24,
                      bottom: 24,
                    ),
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs;
                      return ContentCard(
                        showPlay: true,
                        nameEn: data[index]['title_en'],
                        nameNp: 'nameNp',
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
                          data[index]['media']['youtube_link'],
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
    );
  }
}
