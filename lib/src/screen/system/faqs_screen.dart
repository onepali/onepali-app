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
      return Center(
        child: Text(
          'No FAQs available',
          style:
              isMobilePortrait
                  ? AppStyles.text16PxRegular.copyWith(color: Colors.grey)
                  : AppStyles.text20PxRegular.copyWith(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobilePortrait ? 16.0 : 32.0),
      itemCount: widget.faqsData.length,
      itemBuilder: (context, index) {
        final faq = widget.faqsData[index];
        return Card(
          margin: EdgeInsets.only(bottom: isMobilePortrait ? 12 : 20),
          elevation: 1,
          color: AppColors.kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobilePortrait ? 12 : 16),
          ),
          child: ExpansionTile(
            key: Key('faq_$index${_expandedIndex == index ? '_expanded' : ''}'),
            initiallyExpanded: _expandedIndex == index,
            onExpansionChanged: (isExpanded) {
              setState(() {
                _expandedIndex = isExpanded ? index : null;
              });
            },
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
            iconColor: AppColors.kPrimaryColor,
            collapsedIconColor: AppColors.kSecondaryColor,
            title: Text(
              faq.title,
              style:
                  isMobilePortrait
                      ? AppStyles.text16PxSemiBold.copyWith(
                        color: AppColors.kSecondaryColor,
                      )
                      : AppStyles.text20PxSemiBold.copyWith(
                        color: AppColors.kSecondaryColor,
                      ),
            ),
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobilePortrait ? 12 : 16),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(
                    isMobilePortrait ? 8 : 12,
                  ),
                ),
                child: Text(
                  faq.answer,
                  style:
                      isMobilePortrait
                          ? AppStyles.text14PxRegular.copyWith(
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
