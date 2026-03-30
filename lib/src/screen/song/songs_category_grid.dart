import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/screen/song/new_songs_screen.dart';
import 'package:provider/provider.dart';

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
    return SafeArea(
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
              childAspectRatio: 3 / 2.0,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
                      builder: (context) =>
                          NewSongsScreen(categoryId: data[index]['id'],
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
