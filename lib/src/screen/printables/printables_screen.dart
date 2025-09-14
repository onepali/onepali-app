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
                    _buildSearchBar(printablesProvider),
                    Expanded(child: _buildPrintablesList(printablesProvider)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar(PrintablesProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextFormField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        autofocus: false,
        onChanged: (value) {
          provider.updateSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search printables...',
          hintStyle: AppStyles.text14PxRegular.copyWith(color: AppColors.kGrey),
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
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPrintablesList(PrintablesProvider provider) {
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
            Text(
              'No printables found',
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

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredPrintables.length,
      separatorBuilder: (context, index) => Gaps.verticalGapOf(16),
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
