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
    final bool isMobilePortrait =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isPortrait(context);

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
          margin: EdgeInsets.only(bottom: isMobilePortrait ? 12 : 20),

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
              horizontal: isMobilePortrait ? 16 : 24,
              vertical: isMobilePortrait ? 8 : 12,
            ),
            childrenPadding: EdgeInsets.fromLTRB(
              isMobilePortrait ? 16 : 24,
              0,
              isMobilePortrait ? 16 : 24,
              isMobilePortrait ? 16 : 24,
            ),
            iconColor: AppColors.kSecondaryColor,
            collapsedIconColor: AppColors.kPitchBlack,

            title: Text(
              faq.title,
              style:
                  isMobilePortrait
                      ? _expandedIndex == index
                          ? AppStyles.text16PxSemiBold.copyWith(
                            color: AppColors.kSecondaryColor,
                          )
                          : AppStyles.text16PxMedium.copyWith(
                            color: AppColors.kPitchBlack,
                          )
                      : _expandedIndex == index
                      ? AppStyles.text20PxSemiBold.copyWith(
                        color: AppColors.kSecondaryColor,
                      )
                      : AppStyles.text20PxMedium.copyWith(
                        color: AppColors.kPitchBlack,
                      ),
            ),
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobilePortrait ? 12 : 16),
                decoration: BoxDecoration(
                  color: AppColors.kLightGrey.withValues(alpha: 0.3),
                  border: Border(
                    left: BorderSide(
                      color: AppColors.kPureSkyBlue,
                      width: isMobilePortrait ? 4 : 6,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(
                    isMobilePortrait ? 8 : 12,
                  ),
                ),
                child: Text(
                  faq.answer,
                  style:
                      isMobilePortrait
                          ? AppStyles.text16PxRegular.copyWith(
                            height: 1.5,
                            color: AppColors.kBlack,
                          )
                          : AppStyles.text18PxRegular.copyWith(
                            height: 1.5,
                            color: AppColors.kBlack,
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
