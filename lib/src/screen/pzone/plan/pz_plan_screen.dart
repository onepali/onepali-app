import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../src.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PzPlanProvider>(
      builder: (context, planProvider, _) {
        final plan = planProvider.currentPlan;
        return StatusHandler(
          status: planProvider.status,
          hasData: true,
          errorTitle: 'Error Loading Plan',
          errorMessage: 'Please try again later.',
          onRetry: () {},
          successBuilder: () {
            return Scaffold(
              appBar: CustomAppBar(
                title: 'My Plan',
                backgroundColor: AppColors.kWhite,
              ),
              backgroundColor: AppColors.kWhite,
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlanCard(
                      planName: plan?.name ?? 'Free',
                      activeDate: planProvider.activeDate,
                      expiryDate: planProvider.expiryDate,
                      isFree: (plan?.id ?? 'free') == 'free',
                    ),
                    Gaps.verticalGapOf(24),
                    Text(
                      (plan?.id ?? 'free') == 'free'
                          ? 'Upgrade to unlock more features.'
                          : 'Any issues with your plan?',
                      style: AppStyles.text14PxRegular,
                    ),
                    if ((plan?.id ?? 'free') == 'free')
                      Text(
                        'Contact customer support.',
                        style: AppStyles.text14PxRegular.copyWith(
                          color: AppColors.kBlue,
                        ),
                      ),
                  ],
                ),
              ),
              bottomNavigationBar:
                  ((plan?.id ?? 'free') == 'free'
                      ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomMaterialButton(
                          label: 'Upgrade and save 5,99 a month',
                          onTap: () {},
                          backgroundColor: AppColors.kButtonGreen,
                          elevation: 0,
                        ),
                      )
                      : null),
            );
          },
        );
      },
    );
  }
}
