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
      context.read<ChildUserProvider>().fetchChildUser();
    });
  }

  double _getCardWidth(BuildContext context) {
    return AppCardResponsive.getCardWidth(context);
  }

  double _getCardHeight(BuildContext context) {
    bool isTablet = PlatformUtility.isTablet(context);
    return isTablet
        ? AppCardResponsive.getCardHeight(context) *
              0.8 // 20% smaller for tablets
        : AppCardResponsive.getCardHeight(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    return Consumer<SongProvider>(
      builder: (context, songProvider, child) {
        return StatusHandler(
          status: songProvider.status,
          hasData: songProvider.songs.isNotEmpty,
          errorTitle: 'No songs available',
          errorMessage: 'Please check back later for new songs.',
          checkConnectivity: false,
          onRetry: () {
            context.read<SongProvider>().fetchSongs();
          },
          successBuilder: () {
            final songs = widget.showCategoryList && selectedCategory != null
                ? songProvider.songs
                      .where((s) => s.categoryName == selectedCategory)
                      .toList()
                : songProvider.songs;
            final categories = songProvider.songs
                .map((s) => s.categoryName)
                .toSet()
                .where((c) => c.isNotEmpty)
                .toList();
            return Scaffold(
              appBar: widget.showCategoryList
                  ? CustomAppBar(title: 'Songs', centerTitle: false)
                  : null,
              backgroundColor: AppColors.kWhite,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showCategoryList)
                    SizedBox(
                      height: isTabletLandscape ? 60 : 48,
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
                                  color: selectedCategory == cat
                                      ? AppColors.kWhite
                                      : AppColors.kPitchBlack,
                                  fontSize: isTabletLandscape ? 18 : 14,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              selectedColor: AppColors.kButtonGreen,
                              selected: selectedCategory == cat,
                              checkmarkColor: AppColors.kWhite,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              side: BorderSide(
                                color: selectedCategory == cat
                                    ? AppColors.kButtonGreen
                                    : AppColors.kGrey,
                              ),
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
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        logger.d(
                          'SongScreen: songId: ${song.id}, title: ${song.titleEn}, category: ${song.categoryName}',
                        );
                        return SizedBox(
                          width: _getCardWidth(context),
                          height: _getCardHeight(context),
                          child: SongCard(
                            index: index,
                            data: song,
                            isGuestUser: GuestUtil.isGuestUser(),
                            // initialPosition: rec.progress, // Only for recommended, not for all songs
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
