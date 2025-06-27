import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/screen/system/about_us_screen.dart';
import 'package:onepali/src/screen/system/contact_screen.dart';
import 'package:onepali/src/screen/system/faqs_screen.dart';

class SystemScreen extends StatefulWidget {
  final int initialIndex;
  const SystemScreen({super.key, this.initialIndex = 0});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.sysTab.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    Misc.onLayoutRendered(() {
      context.read<SystemProvider>().fetchSystemData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobilePortrait =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isPortrait(context);

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        backgroundColor: AppColors.kSecondaryColor,
        title: SvgHelper.fromSource(
          path: Assets.logoSvg,
          height: isMobilePortrait ? 20 : 28,
          color: AppColors.kWhite,
        ),
        iconTheme: const IconThemeData(color: AppColors.kWhite),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.kWhite,
          indicatorWeight: 3,
          labelColor: AppColors.kWhite,
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor: AppColors.kWhite.withValues(alpha: 0.7),
          labelStyle:
              isMobilePortrait
                  ? AppStyles.text14PxSemiBold.copyWith(color: AppColors.kWhite)
                  : AppStyles.text18PxSemiBold.copyWith(
                    color: AppColors.kWhite,
                  ),
          unselectedLabelStyle:
              isMobilePortrait
                  ? AppStyles.text14PxRegular.copyWith(
                    color: AppColors.kWhite.withValues(alpha: 0.7),
                  )
                  : AppStyles.text18PxRegular.copyWith(
                    color: AppColors.kWhite.withValues(alpha: 0.7),
                  ),
          tabs: AppConstants.sysTab.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: Consumer<SystemProvider>(
        builder: (context, provider, child) {
          if (provider.status == DataFetchStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.status == DataFetchStatus.error) {
            return const Center(child: Text('Error loading system data'));
          }

          return TabBarView(
            controller: _tabController,
            children: [
              AboutUsScreen(aboutData: provider.aboutData),
              ContactScreen(contactData: provider.contactData),
              FaqsScreen(faqsData: provider.faqsData),
            ],
          );
        },
      ),
    );
  }
}
