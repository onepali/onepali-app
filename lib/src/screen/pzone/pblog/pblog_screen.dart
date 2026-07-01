import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class ParentBlogScreen extends StatefulWidget {
  const ParentBlogScreen({super.key});

  @override
  State<ParentBlogScreen> createState() => _ParentBlogScreenState();
}

class _ParentBlogScreenState extends State<ParentBlogScreen> {
  @override
  void initState() {
    super.initState();
    // Note: Orientation is handled by OrientationRouteObserver
    // We don't set orientation here to avoid conflicts
    Misc.onLayoutRendered(() async {
      context.read<PzBlogProvider>().fetchBlogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Consumer<PzBlogProvider>(
        builder: (context, provider, _) {
          return StatusHandler(
            status: provider.status,
            hasData: provider.blogs.isNotEmpty,
            errorTitle: 'No blogs available',
            errorMessage: 'Please check back later for new blogs.',
            onRetry: () => context.read<PzBlogProvider>().fetchBlogs(),
            successBuilder: () => ListView.separated(
              itemCount: provider.blogs.length,
              separatorBuilder: (context, index) => SizedBox(
                height: 50,
                child: Divider(color: AppColors.kLightGrey, thickness: 0.2),
              ),
              itemBuilder: (context, index) {
                final blog = provider.blogs[index];
                return PBlogCard(
                  blog: blog,
                  onTap: () {
                    Utility.navigateMaterialRoute(
                      context,
                      PBlogDetailScreen(data: blog),
                      routeName: AppRoutes.blogDetailScreen,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
