import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class PrintableDetailScreen extends StatefulWidget {
  final PrintableModel printable;

  const PrintableDetailScreen({super.key, required this.printable});

  @override
  State<PrintableDetailScreen> createState() => _PrintableDetailScreenState();
}

class _PrintableDetailScreenState extends State<PrintableDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<PrintablesProvider>().clearSelection();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrintablesProvider>(
      builder: (context, provider, child) {
        final selectedFromThisPrintable = widget.printable.lessons
            .where((lesson) => provider.selectedWorksheets.contains(lesson.id))
            .length;

        return GestureDetector(
          onTap: () {
            _searchFocusNode.unfocus();
          },
          child: Scaffold(
            backgroundColor: AppColors.kWhite,
            appBar: CustomAppBar(
              title: selectedFromThisPrintable > 0
                  ? '$selectedFromThisPrintable ${selectedFromThisPrintable > 1 ? 'worksheets' : 'worksheet'} selected'
                  : widget.printable.title,
              centerTitle: false,
            ),
            body: Column(
              children: [
                _buildSearchBar(),
                _buildDownloadAllButton(provider),
                Expanded(child: _buildWorksheetsList(provider)),
              ],
            ),
            bottomNavigationBar: _buildBottomBar(
              provider,
              selectedFromThisPrintable,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    final bool isMobile = PlatformUtility.isMobile(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double searchBarMargin = isMobile ? 16.0 : 20.0;
    final double searchBarVerticalPadding = isMobile ? 12.0 : 16.0;
    final double searchBarBorderRadius = isMobile ? 12.0 : 16.0;
    final double searchBarHorizontalPadding = isMobile ? 16.0 : 20.0;

    return Container(
      margin: EdgeInsets.all(searchBarMargin),
      child: TextFormField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        autofocus: false,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search worksheets...',
          hintStyle: AppStyles.text14PxRegular.copyWith(color: AppColors.kGrey),
          prefixIcon: const Icon(Icons.search, color: AppColors.kGrey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.kGrey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.kBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(searchBarBorderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: searchBarHorizontalPadding,
            vertical: searchBarVerticalPadding,
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadAllButton(PrintablesProvider provider) {
    final bool isMobile = PlatformUtility.isMobile(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double buttonMargin = isMobile ? 16.0 : 20.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: buttonMargin),
      child: CustomMaterialButton(
        onTap: provider.isDownloading
            ? null
            : () async {
                await provider.downloadAllWorksheets(widget.printable);
              },
        elevation: 0,
        height: isMobile ? 48 : 56,
        textStyle: isMobile
            ? AppStyles.text16PxMedium
            : AppStyles.text18PxMedium,
        isLoading: provider.isDownloading,
        label: 'Download all (${widget.printable.totalWorksheets})',
      ),
    );
  }

  Widget _buildWorksheetsList(PrintablesProvider provider) {
    final bool isMobile = PlatformUtility.isMobile(context);
    final bool isMobilePortrait =
        isMobile && MediaQuery.of(context).orientation == Orientation.portrait;

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double gridPadding = isMobile ? 16.0 : 20.0;
    final double crossAxisSpacing = isMobile ? 12.0 : 16.0;
    final double mainAxisSpacing = isMobile ? 12.0 : 16.0;
    final int crossAxisCount = isMobile ? (isMobilePortrait ? 3 : 4) : 4;
    final double childAspectRatio = isMobile ? (2 / 2) : (2.2 / 2);

    // Filter lessons based on search query
    final filteredLessons = widget.printable.lessons.where((lesson) {
      if (_searchQuery.isEmpty) return true;
      return lesson.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredLessons.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.kGrey.withValues(alpha: 0.5),
            ),
            Gaps.verticalGapOf(16),
            Text(
              'No worksheets found',
              style: AppStyles.text16PxRegular.copyWith(color: AppColors.kGrey),
            ),
            Gaps.verticalGapOf(8),
            Text(
              'Try adjusting your search terms',
              style: AppStyles.text14PxRegular.copyWith(color: AppColors.kGrey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(gridPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: filteredLessons.length,
      itemBuilder: (context, index) {
        final lesson = filteredLessons[index];
        final isSelected = provider.selectedWorksheets.contains(lesson.id);
        final isDownloading =
            provider.isDownloading &&
            provider.downloadingWorksheetId == lesson.id;

        return _buildWorksheetCard(
          lesson: lesson,
          isSelected: isSelected,
          isDownloading: isDownloading,
          provider: provider,
        );
      },
    );
  }

  Widget _buildWorksheetCard({
    required PLesson lesson,
    required bool isSelected,
    required bool isDownloading,
    required PrintablesProvider provider,
  }) {
    final bool isMobile = PlatformUtility.isMobile(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double cardPadding = isMobile ? 16.0 : 20.0;
    final double cardBorderRadius = isMobile ? 12.0 : 16.0;
    final double borderWidth = isSelected ? 1.5 : 1.0;
    final TextStyle textStyle = isMobile
        ? AppStyles.text16PxRegular.copyWith(color: AppColors.kBlack)
        : AppStyles.text18PxMedium.copyWith(color: AppColors.kBlack);

    return GestureDetector(
      onTap: () {
        provider.toggleWorksheetSelection(lesson.id);
      },
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kButtonGreen.withValues(alpha: 0.2)
              : AppColors.kWhite,

          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: AppColors.kLightGrey, width: borderWidth),
        ),
        alignment: Alignment.center,
        child: Text(
          lesson.title,
          style: textStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget? _buildBottomBar(PrintablesProvider provider, int selectedCount) {
    if (selectedCount == 0) return null;

    final bool isMobile = PlatformUtility.isMobile(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double bottomBarPadding = isMobile ? 16.0 : 20.0;

    return Container(
      padding: EdgeInsets.all(bottomBarPadding),
      decoration: const BoxDecoration(
        color: AppColors.kWhite,
        border: Border(
          top: BorderSide(color: AppColors.kLightGrey, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: CustomMaterialButton(
          onTap: provider.isDownloading
              ? null
              : () {
                  final selectedLessons = widget.printable.lessons
                      .where(
                        (lesson) =>
                            provider.selectedWorksheets.contains(lesson.id),
                      )
                      .toList();

                  for (final lesson in selectedLessons) {
                    provider.downloadWorksheet(lesson, widget.printable.title);
                  }
                },
          isLoading: provider.isDownloading,
          radius: 60,
          height: isMobile ? 48 : 56,
          textStyle: isMobile
              ? AppStyles.text16PxMedium
              : AppStyles.text18PxMedium,
          elevation: 0,
          label:
              'Download $selectedCount worksheet${selectedCount > 1 ? 's' : ''}',
        ),
      ),
    );
  }
}
