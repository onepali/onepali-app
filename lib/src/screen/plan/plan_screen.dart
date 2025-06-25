import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../src.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PzPlanProvider>(
      builder: (context, planProvider, _) {
        final plan = planProvider.currentPlan;
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Plan'),
            leading: BackButton(),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          backgroundColor: Colors.white,
          body:
              planProvider.status == DataFetchStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlanCard(
                          planName: plan?.name ?? 'Free',
                          activeDate: planProvider.activeDate,
                          expiryDate: planProvider.expiryDate,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Any issue with your plan?',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              bottom: 24.0,
                            ),
                            child: const Text(
                              'Contact customer support.',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        CustomMaterialButton(
                          label: 'Upgrade and save 5,99 a month',
                          onTap: () {},
                          backgroundColor: const Color(0xFF2AD2C9),
                          color: Colors.black,
                          radius: 14,
                          height: 54,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
