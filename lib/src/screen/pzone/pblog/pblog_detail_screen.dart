import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class PBlogDetailScreen extends StatefulWidget {
  final PzBlogModel? data;
  const PBlogDetailScreen({super.key, this.data});

  @override
  State<PBlogDetailScreen> createState() => _PBlogDetailScreenState();
}

class _PBlogDetailScreenState extends State<PBlogDetailScreen> {
  @override
  void initState() {
    super.initState();
    final blog = widget.data;
    if (blog != null) {
      Misc.onLayoutRendered(() {
        context.read<PzBlogProvider>().incrementBlogView(blog.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);

    var blog = widget.data;
    if (blog == null) {
      return const Scaffold(body: Center(child: Text('Blog data is loading')));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: AppColors.kWhite),
        child: Row(
          children: [
            Icon(Icons.timer, size: 18, color: Colors.grey[600]),
            Gaps.horizontalGapOf(4),
            Text(
              '${blog.readTimeMinutes} min read',
              style: const TextStyle(fontSize: 13),
            ),
            const Spacer(),
            Text(
              'Published: ${DatetimeUtility.getFormattedDate(blog.createdAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: AppColors.kWhite),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CustomImage(
                  blog.coverImage,
                  width: double.infinity,
                  height: isMobilePortrait ? 200 : 150,
                  imageType: CustomImageType.network,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomImage(
                          blog.authorAvatar,
                          width: 40,
                          height: 40,
                          borderRadius: 20,
                          imageType: CustomImageType.network,
                        ),
                        Gaps.horizontalGapOf(10),
                        Expanded(
                          child: Text(
                            blog.authorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.visibility,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        Gaps.horizontalGapOf(2),
                        Text(
                          '${blog.viewCount}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        Gaps.horizontalGapOf(10),
                      ],
                    ),
                    Gaps.verticalGapOf(16),
                    Text(
                      blog.title,
                      style:
                          isMobilePortrait
                              ? AppStyles.text20PxSemiBold
                              : AppStyles.text24PxSemiBold,
                    ),
                    Gaps.verticalGapOf(10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   spacing: 8,
                    //   children:
                    //       blog.tags
                    //           .map((e) => CustomRoundedBox(title: e))
                    //           .toList(),
                    // ),
                    // Gaps.verticalGapOf(18),
                    Text(
                      blog.content,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    Gaps.verticalGapOf(24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
