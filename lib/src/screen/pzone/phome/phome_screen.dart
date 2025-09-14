import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../src.dart';

class PHomeScreen extends StatefulWidget {
  const PHomeScreen({super.key});

  @override
  State<PHomeScreen> createState() => _PHomeScreenState();
}

class _PHomeScreenState extends State<PHomeScreen> {
  String? selectedChildUid;

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() async {
      context.read<UserProvider>().fetchOwnProfile();
      await context.read<ChildUserProvider>().fetchChildUser();

      // Set default selected child from local storage
      await _setDefaultSelectedChild();
    });
  }

  Future<void> _setDefaultSelectedChild() async {
    final currentChildId = await ChildLocalStorage.getCurrentChildId();
    final children = context.read<ChildUserProvider>().childUser;

    if (children.isNotEmpty) {
      String defaultChildId;

      // If current child ID exists and is valid, use it
      if (currentChildId != null &&
          currentChildId.isNotEmpty &&
          children.any((child) => child.uid == currentChildId)) {
        defaultChildId = currentChildId;
      } else {
        // Otherwise, use the first child as default
        defaultChildId = children.first.uid;
      }

      // Set the selected child and fetch metrics
      _onChildSelected(defaultChildId);
    }
  }

  void _onChildSelected(String childUid) {
    setState(() {
      selectedChildUid = childUid;
    });

    // Fetch metrics for selected child
    final parentUid = context.read<UserProvider>().userId;
    if (parentUid != null) {
      context.read<PzMetricsProvider>().fetchMetrics(
        parentUid: parentUid,
        childUid: childUid,
      )
      // .then((_) {
      //   if (!mounted) return;
      //   context.read<PzMetricsProvider>().checkAndResetWeeklyStreak(
      //     parentUid: parentUid,
      //     childUid: childUid,
      //   );
      // })
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobilePortrait =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isPortrait(context);

    return Consumer3<UserProvider, ChildUserProvider, PzMetricsProvider>(
      builder: (context, userProvider, childProvider, metricsProvider, _) {
        final parentUid = userProvider.userId;
        final children = childProvider.childUser;
        final metrics = metricsProvider.metrics;
        final metricsStatus = metricsProvider.status;
        final childStatus = childProvider.status;

        return Scaffold(
          backgroundColor: AppColors.kBackgroundColor,
          body: StatusHandler(
            status: childStatus,
            hasData: children.isNotEmpty,
            errorTitle: 'No child found',
            errorMessage: 'Please add a child to view metrics.',
            onRetry: () {
              context.read<ChildUserProvider>().fetchChildUser();
            },
            successBuilder: () {
              return PHomeCard(
                children: children,
                selectedChildUid: selectedChildUid,
                onChildSelected: _onChildSelected,
                metrics: metrics,
                metricsStatus: metricsStatus,
                isMobilePortrait: isMobilePortrait,
                parentUid: parentUid,
              );
            },
          ),
        );
      },
    );
  }
}
