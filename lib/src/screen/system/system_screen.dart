import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../src.dart';

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
          height: isMobilePortrait ? 24 : 30,
          color: AppColors.kWhite,
        ),
        iconTheme: const IconThemeData(color: AppColors.kWhite),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.kPureSkyBlue,
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
          dividerColor: Colors.transparent,
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
          return StatusHandler(
            status: provider.status,
            hasData: true,
            errorTitle: 'Error Fetching Data',
            errorMessage: 'Please try again later.',
            onRetry: () {
              context.read<SystemProvider>().fetchSystemData();
            },
            successBuilder: () {
              return TabBarView(
                controller: _tabController,
                children: [
                  AboutUsScreen(aboutData: provider.aboutData),
                  ContactScreen(contactData: provider.contactData),
                  FaqsScreen(faqsData: provider.faqsData),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
