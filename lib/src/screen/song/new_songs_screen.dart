import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/src.dart';

class NewSongsScreen extends StatelessWidget {
  final String categoryId;
  const NewSongsScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs;
                      return ContentCard(
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
                                // childId: childId,
                              ),
                            ),
                          );
                        },
                        image: null,
                        bgImage: Utility.generateYoutubeThumbnailUrl(
                          data[index]['media']['youtube_link'],
                        ),
                      );
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              Utility.generateYoutubeThumbnailUrl(
                                data[index]['media']['youtube_link'],
                              ),
                            ),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              logger.e('Error loading image: $exception');
                              AssetImage(Assets.placeholder);
                            },
                          ),
                        ),
                        child: Text('data'),
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
