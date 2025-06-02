import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class SongScreen extends StatefulWidget {
  final bool showCategoryList;
  const SongScreen({super.key, this.showCategoryList = false});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<SongProvider>().fetchSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<SongProvider>(
          builder: (context, songProvider, child) {
            if (songProvider.status == DataFetchStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (songProvider.status == DataFetchStatus.error ||
                songProvider.songs.isEmpty) {
              return const Center(child: Text('No songs available'));
            } else {
              final songs =
                  widget.showCategoryList && selectedCategory != null
                      ? songProvider.songs
                          .where((s) => s.categoryName == selectedCategory)
                          .toList()
                      : songProvider.songs;
              final categories =
                  songProvider.songs
                      .map((s) => s.categoryName)
                      .toSet()
                      .where((c) => c.isNotEmpty)
                      .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showCategoryList)
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, idx) {
                          final cat = categories[idx];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ChoiceChip(
                              label: Text(
                                cat,
                                style: AppStyles.text14PxMedium.copyWith(
                                  color:
                                      selectedCategory == cat
                                          ? AppColors.kWhite
                                          : AppColors.kPitchBlack,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              selected: selectedCategory == cat,
                              checkmarkColor: AppColors.kWhite,
                              onSelected: (_) {
                                setState(() {
                                  selectedCategory = cat;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: songs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        logger.d(
                          'SongScreen: songId: ${song.id}, title: ${song.titleEn}, category: ${song.categoryName}',
                        );
                        return SongCard(index: index, data: song);
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
