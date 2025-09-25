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

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double imageHeight = isMobile
        ? (isMobilePortrait ? 200 : 150)
        : 450; // Enhanced for tablet
    final double horizontalPadding = isMobile
        ? (isMobilePortrait ? 24 : 72.0)
        : 100.0; // Enhanced for tablet
    final double verticalPadding = isMobile
        ? (isMobilePortrait ? 16 : 32)
        : 40; // Enhanced for tablet
    final double bottomPadding = isMobile ? 16.0 : 24.0;
    final double avatarSize = isMobile ? 40 : 50;
    final double iconSize = isMobile ? 18 : 22;

    final TextStyle titleStyleAppBar = isMobile
        ? AppStyles.text16PxSemiBold.copyWith(
            fontFamily: AppConstants.kPoppinsFont,
          )
        : AppStyles.text20PxSemiBold.copyWith(
            fontFamily: AppConstants.kPoppinsFont,
          );

    final TextStyle titleStyleMain = isMobile
        ? (isMobilePortrait
              ? AppStyles.text20PxSemiBold
              : AppStyles.text24PxSemiBold)
        : AppStyles.text28PxSemiBold; // Enhanced for tablet

    final TextStyle authorStyle = isMobile
        ? AppStyles.text16PxMedium
        : AppStyles.text18PxMedium;

    final TextStyle contentStyle = isMobile
        ? AppStyles.text16PxRegular.copyWith(
            height: 1.5,
            fontFamily: AppConstants.kDMSansFont,
          )
        : AppStyles.text18PxRegular.copyWith(
            height: 1.6,
            fontFamily: AppConstants.kDMSansFont,
          ); // Enhanced for tablet

    var blog = widget.data;
    if (blog == null) {
      return const Scaffold(body: Center(child: Text('Blog data is loading')));
    }
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        title: Text(
          blog.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleStyleAppBar,
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(bottomPadding),
        decoration: BoxDecoration(color: AppColors.kWhite),
        child: Row(
          children: [
            Icon(Icons.timer, size: iconSize, color: AppColors.kGrey),
            Gaps.horizontalGapOf(4),
            Text(
              '${blog.readTimeMinutes} min read',
              style: AppStyles.text12PxRegular.copyWith(
                color: AppColors.kGrey,
                fontFamily: AppConstants.kDMSansFont,
                fontSize: isMobile ? 12.0 : 16.0,
              ),
            ),
            const Spacer(),
            Text(
              'Published: ${DatetimeUtility.getFormattedDate(blog.createdAt)}',
              style: AppStyles.text12PxRegular.copyWith(
                color: AppColors.kGrey.withValues(alpha: 0.7),
                fontFamily: AppConstants.kDMSansFont,
                fontSize: isMobile ? 12.0 : 16.0,
              ),
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
              CustomImage(
                blog.coverImage,
                width: double.infinity,
                height: imageHeight,
                imageType: CustomImageType.network,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomImage(
                          blog.authorAvatar,
                          width: avatarSize,
                          height: avatarSize,
                          borderRadius: avatarSize / 2,
                          imageType: CustomImageType.network,
                        ),
                        Gaps.horizontalGapOf(10),
                        Expanded(
                          child: Text(blog.authorName, style: authorStyle),
                        ),
                        Icon(
                          Icons.visibility,
                          size: iconSize,
                          color: Colors.grey[600],
                        ),
                        Gaps.horizontalGapOf(2),
                        Text(
                          '${blog.viewCount}',
                          style: AppStyles.text12PxRegular.copyWith(
                            color: AppColors.kGrey,
                            fontFamily: AppConstants.kDMSansFont,
                            fontSize: isMobile ? 12.0 : 16.0,
                          ),
                        ),
                        Gaps.horizontalGapOf(10),
                      ],
                    ),
                    Gaps.verticalGapOf(16),
                    Text(blog.title, style: titleStyleMain),
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
                      style: contentStyle,
                      textAlign: TextAlign.justify,
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
