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
    Misc.onLayoutRendered(() {
      context.read<UserProvider>().fetchOwnProfile();
      context.read<ChildUserProvider>().fetchChildUser();
    });
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
      );
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

        // Set first child as default if not selected
        if (children.isNotEmpty && selectedChildUid == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _onChildSelected(children.first.uid);
          });
        }

        return Scaffold(
          backgroundColor: AppColors.kBackgroundColor,
          body:
              childStatus == DataFetchStatus.loading
                  ? CustomLoader()
                  : children.isEmpty
                  ? const Center(
                    child: Text(
                      'No child found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                  : PHomeCard(
                    children: children,
                    selectedChildUid: selectedChildUid,
                    onChildSelected: _onChildSelected,
                    metrics: metrics,
                    metricsStatus: metricsStatus,
                    isMobilePortrait: isMobilePortrait,
                    parentUid: parentUid,
                  ),
        );
      },
    );
  }
}
