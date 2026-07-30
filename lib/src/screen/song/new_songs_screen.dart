import 'package:cloud_firestore/cloud_firestore.dart';
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
  Set<String> _completedSongIds = <String>{};

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(_loadCompletedSongIds);
  }

  Future<void> _loadCompletedSongIds() async {
    final completedSongIds =
        await MetricsTrackingHelper.fetchCompletedContentIds(
          context: context,
          activityType: ActivityType.song,
        );
    if (!mounted) return;
    setState(() {
      _completedSongIds = completedSongIds;
    });
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
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final closeButtonPadding = isMobile
        ? closeBtnPositionMobile
        : closeBtnPositionTablet;
    final closeButtonSize = isMobile
        ? closeBtnIconSizeMobile
        : closeBtnIconSizeTablet;

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            right: false,
            bottom: false,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: closeButtonPadding,
                      right: closeButtonPadding + closeButtonSize,
                    ),
                    child: Center(
                      child: _buildTitleText(context, widget.title),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: closeButtonPadding,
                        bottom: closeButtonPadding,
                        right: closeButtonPadding,
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
                  return SafeArea(
                    right: false,
                    bottom: false,
                    top: false,
                    child: GridView.builder(
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 2.0,
                        mainAxisSpacing: 24.0,
                        crossAxisSpacing: 24.0,
                      ),
                      padding: const EdgeInsets.only(
                        right: 24,
                        left: 24,
                        bottom: 24,
                      ),
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs;
                        final songDoc = data[index];
                        return ContentCard(
                          showPlay: true,
                          isCompleted: _completedSongIds.contains(songDoc.id),
                          nameEn: songDoc['title_en'],
                          nameNp: 'nameNp',
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SongVideoPlayerScreen(
                                  youtubeUrl: songDoc['media']['youtube_link'],
                                  title: songDoc['title_en'],
                                  subtitle: '',
                                  isLocked: false,
                                  info: '',
                                  songId: songDoc.id,
                                  initialPosition: 0.0,
                                  image: Utility.generateYoutubeThumbnailUrl(
                                    songDoc['media']['youtube_link'],
                                  ),
                                ),
                              ),
                            );
                            if (!context.mounted) return;
                            await _loadCompletedSongIds();
                          },
                          image: null,
                          bgImage: Utility.generateYoutubeThumbnailUrl(
                            songDoc['media']['youtube_link'],
                          ),
                        );
                      },
                    ),
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
