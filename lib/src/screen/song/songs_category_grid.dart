import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/screen/song/new_songs_screen.dart';

class SongsCategoryGrid extends StatefulWidget {
  const SongsCategoryGrid({super.key});

  @override
  State<SongsCategoryGrid> createState() => _SongsCategoryGridState();
}

class _SongsCategoryGridState extends State<SongsCategoryGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return SafeArea(
      right: true,
      bottom: false,
      top: false,
      left: true,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('song_categories')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            itemCount: snapshot.data!.docs.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: AppConstants.contentCardAspectRatio,
              mainAxisSpacing: 24.0,
              crossAxisSpacing: 24.0,
            ),
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs;
              return ContentCard(
                nameEn: data[index]['name_en'],
                nameNp: data[index]['name_np'],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewSongsScreen(
                        categoryId: data[index]['id'],
                        title: data[index]['name_en'],
                      ),
                    ),
                  );
                },
                image: null,
                bgImage: data[index]['image'],
              );
            },
          );
        },
      ),
    );
  }
}
