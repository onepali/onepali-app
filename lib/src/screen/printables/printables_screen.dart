import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class PrintablesScreen extends StatefulWidget {
  const PrintablesScreen({super.key});

  @override
  State<PrintablesScreen> createState() => _PrintablesScreenState();
}

class _PrintablesScreenState extends State<PrintablesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<PrintablesProvider>().fetchPrintables();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Misc.onLayoutRendered(() {
      if (_searchFocusNode.hasFocus) {
        _searchFocusNode.unfocus();
      }
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
    final bool isMobile = PlatformUtility.isMobile(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double searchMargin = isMobile ? 16.0 : 24.0;
    final double listPadding = isMobile ? 16.0 : 24.0;
    final double itemSpacing = isMobile ? 16.0 : 20.0;
    final int crossAxisCount =
        isMobile ? 1 : 2; // Mobile: ListView, Tablet: GridView

    final TextStyle hintStyle =
        isMobile
            ? AppStyles.text14PxRegular.copyWith(color: AppColors.kGrey)
            : AppStyles.text16PxRegular.copyWith(color: AppColors.kGrey);

    final TextStyle noResultsTitleStyle =
        isMobile
            ? AppStyles.text16PxRegular.copyWith(color: AppColors.kGrey)
            : AppStyles.text18PxRegular.copyWith(color: AppColors.kGrey);

    final TextStyle noResultsSubStyle =
        isMobile
            ? AppStyles.text14PxRegular.copyWith(color: AppColors.kGrey)
            : AppStyles.text16PxRegular.copyWith(color: AppColors.kGrey);
    return Consumer<PrintablesProvider>(
      builder: (context, printablesProvider, child) {
        return StatusHandler(
          status: printablesProvider.status,
          hasData: printablesProvider.printables.isNotEmpty,
          errorTitle: 'No printables available',
          errorMessage: 'Please check back later for new printables.',
          onRetry: () {
            context.read<PrintablesProvider>().fetchPrintables();
          },
          successBuilder: () {
            return GestureDetector(
              onTap: () {
                // Unfocus search field when tapping outside
                _searchFocusNode.unfocus();
              },
              child: Scaffold(
                backgroundColor: AppColors.kWhite,
                appBar: CustomAppBar(title: 'Printables'),
                body: Column(
                  children: [
                    _buildSearchBar(
                      printablesProvider,
                      searchMargin,
                      hintStyle,
                    ),
                    Expanded(
                      child: _buildPrintablesList(
                        printablesProvider,
                        listPadding,
                        itemSpacing,
                        crossAxisCount,
                        noResultsTitleStyle,
                        noResultsSubStyle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar(
    PrintablesProvider provider,
    double searchMargin,
    TextStyle hintStyle,
  ) {
    final bool isMobile = PlatformUtility.isMobile(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced (same as PrintableDetailScreen)
    final double searchBarVerticalPadding = isMobile ? 12.0 : 16.0;
    final double searchBarBorderRadius = isMobile ? 12.0 : 16.0;
    final double searchBarHorizontalPadding = isMobile ? 16.0 : 20.0;

    return Container(
      margin: EdgeInsets.all(searchMargin),
      child: TextFormField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        autofocus: false,
        onChanged: (value) {
          provider.updateSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search printables...',
          hintStyle: hintStyle,
          prefixIcon: const Icon(Icons.search, color: AppColors.kGrey),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.kGrey),
                    onPressed: () {
                      _searchController.clear();
                      provider.updateSearchQuery('');
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

  Widget _buildPrintablesList(
    PrintablesProvider provider,
    double listPadding,
    double itemSpacing,
    int crossAxisCount,
    TextStyle noResultsTitleStyle,
    TextStyle noResultsSubStyle,
  ) {
    final filteredPrintables = provider.filteredPrintables;

    if (filteredPrintables.isEmpty) {
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
            Text('No printables found', style: noResultsTitleStyle),
            Gaps.verticalGapOf(8),
            Text('Try adjusting your search terms', style: noResultsSubStyle),
          ],
        ),
      );
    }

    // Mobile: ListView, Tablet: GridView
    if (crossAxisCount == 1) {
      // Mobile ListView (unchanged)
      return ListView.separated(
        padding: EdgeInsets.all(listPadding),
        itemCount: filteredPrintables.length,
        separatorBuilder: (context, index) => Gaps.verticalGapOf(itemSpacing),
        itemBuilder: (context, index) {
          final printable = filteredPrintables[index];
          return PrintablesCard(
            printable: printable,
            onTap: () {
              _searchFocusNode.unfocus();
              Utility.navigateMaterialRoute(
                context,
                PrintableDetailScreen(printable: printable),
              );
            },
          );
        },
      );
    } else {
      // Tablet GridView
      return GridView.builder(
        padding: EdgeInsets.all(listPadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: itemSpacing,
          mainAxisSpacing: itemSpacing,
          childAspectRatio:
              3 / 2, // Adjusted for vertical layout (image top, text bottom)
        ),
        itemCount: filteredPrintables.length,
        itemBuilder: (context, index) {
          final printable = filteredPrintables[index];
          return PrintablesCard(
            printable: printable,
            onTap: () {
              _searchFocusNode.unfocus();
              Utility.navigateMaterialRoute(
                context,
                PrintableDetailScreen(printable: printable),
              );
            },
          );
        },
      );
    }
  }
}
