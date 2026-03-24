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

  Widget _buildRainbowText(BuildContext context, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(text.length, (index) {
        return Text(
          text[index],
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontFamily: GoogleFonts.lemon().fontFamily,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors
                .learningColors[index % AppColors.learningColors.length],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.shrink(),
              _buildRainbowText(context, title),
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
