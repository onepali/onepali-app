import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class FaqsScreen extends StatefulWidget {
  final List<FaqModel> faqsData;

  const FaqsScreen({super.key, required this.faqsData});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = PlatformUtility.isMobile(context);
    final bool isMobilePortrait =
        isMobile && PlatformUtility.isPortrait(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double bottomMargin = isMobile ? (isMobilePortrait ? 12 : 20) : 24;
    final double tilePaddingHorizontal =
        isMobile ? (isMobilePortrait ? 16 : 24) : 32;
    final double tilePaddingVertical =
        isMobile ? (isMobilePortrait ? 8 : 12) : 16;
    final double childrenPaddingHorizontal =
        isMobile ? (isMobilePortrait ? 16 : 24) : 32;
    final double childrenPaddingBottom =
        isMobile ? (isMobilePortrait ? 16 : 24) : 32;
    final double answerPadding = isMobile ? (isMobilePortrait ? 12 : 16) : 20;
    final double answerBorderRadius =
        isMobile ? (isMobilePortrait ? 8 : 12) : 16;

    final TextStyle titleStyleExpanded =
        isMobile
            ? (isMobilePortrait
                ? AppStyles.text16PxSemiBold.copyWith(
                  color: AppColors.kDrawerBgColor,
                  fontFamily: AppConstants.kDMSansFont,
                )
                : AppStyles.text20PxSemiBold.copyWith(
                  color: AppColors.kDrawerBgColor,
                  fontFamily: AppConstants.kDMSansFont,
                ))
            : AppStyles.text24PxSemiBold.copyWith(
              color: AppColors.kDrawerBgColor,
              fontFamily: AppConstants.kDMSansFont,
            );

    final TextStyle titleStyleCollapsed =
        isMobile
            ? (isMobilePortrait
                ? AppStyles.text16PxMedium.copyWith(
                  color: AppColors.kPitchBlack,
                  fontFamily: AppConstants.kDMSansFont,
                )
                : AppStyles.text20PxMedium.copyWith(
                  color: AppColors.kPitchBlack,
                  fontFamily: AppConstants.kDMSansFont,
                ))
            : AppStyles.text24PxMedium.copyWith(
              color: AppColors.kPitchBlack,
              fontFamily: AppConstants.kDMSansFont,
            );

    final TextStyle answerStyle =
        isMobile
            ? (isMobilePortrait
                ? AppStyles.text16PxRegular.copyWith(
                  height: 1.5,
                  fontFamily: AppConstants.kDMSansFont,
                  color: AppColors.kDrawerBgColor,
                )
                : AppStyles.text18PxRegular.copyWith(
                  height: 1.5,
                  fontFamily: AppConstants.kDMSansFont,
                  color: AppColors.kDrawerBgColor,
                ))
            : AppStyles.text20PxRegular.copyWith(
              height: 1.6,
              fontFamily: AppConstants.kDMSansFont,
              color: AppColors.kDrawerBgColor,
            );

    if (widget.faqsData.isEmpty) {
      return ErrorScreen(
        title: 'No FAQs Available',
        message: 'Please check back later for new FAQs.',
        isShowButton: false,
      );
    }

    return ListView.separated(
      itemCount: widget.faqsData.length,
      separatorBuilder:
          (context, index) => Divider(
            height: 0,
            thickness: 1,
            color: AppColors.kLightGrey.withValues(alpha: 0.5),
          ),
      itemBuilder: (context, index) {
        final faq = widget.faqsData[index];
        return Container(
          margin: EdgeInsets.only(bottom: bottomMargin),

          color:
              _expandedIndex == index
                  ? AppColors.kLightGrey.withValues(alpha: 0.02)
                  : AppColors.kWhite,
          child: ExpansionTile(
            key: Key('faq_$index${_expandedIndex == index ? '_expanded' : ''}'),
            initiallyExpanded: _expandedIndex == index,
            onExpansionChanged: (isExpanded) {
              setState(() {
                _expandedIndex = isExpanded ? index : null;
              });
            },
            shape: LinearBorder.none,

            tilePadding: EdgeInsets.symmetric(
              horizontal: tilePaddingHorizontal,
              vertical: tilePaddingVertical,
            ),
            childrenPadding: EdgeInsets.fromLTRB(
              childrenPaddingHorizontal,
              0,
              childrenPaddingHorizontal,
              childrenPaddingBottom,
            ),
            iconColor: AppColors.kDrawerBgColor,
            collapsedIconColor: AppColors.kPitchBlack,

            title: Text(
              faq.title,
              style:
                  _expandedIndex == index
                      ? titleStyleExpanded
                      : titleStyleCollapsed,
            ),
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(answerPadding),
                decoration: BoxDecoration(
                  color: AppColors.kLightGrey.withValues(alpha: 0.3),
                  // border: Border(
                  //   left: BorderSide(
                  //     color: AppColors.kPureSkyBlue,
                  //     width: isMobilePortrait ? 4 : 6,
                  //   ),
                  // ),
                  borderRadius: BorderRadius.circular(answerBorderRadius),
                ),
                child: Text(faq.answer, style: answerStyle),
              ),
            ],
          ),
        );
      },
    );
  }
}
