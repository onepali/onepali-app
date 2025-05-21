import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class RS5Screen extends StatefulWidget {
  const RS5Screen({super.key});

  @override
  State<RS5Screen> createState() => _RS5ScreenState();
}

class _RS5ScreenState extends State<RS5Screen> {
  final TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 5),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the Verfication Code',
                style: AppStyles.text20PxSemiBold,
              ),
              Gaps.verticalGapOf(10),
              Text(
                'We have sent a verification code to your email address.',
                style: AppStyles.text14PxRegular,
              ),
              Gaps.verticalGapOf(24),
              CustomPinput(
                length: 4,
                controller: codeController,
                validator: (value) {
                  if (value.length < 4) {
                    return "Please enter all digits";
                  }
                  return Validator.empty(value);
                },
              ),
              Spacer(),
              _buildNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return CustomMaterialButton(
      label: 'Next',
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          final authProvider = context.read<AuthProvider>();
          await authProvider.reloadUser();
          final isVerified = await authProvider.checkEmailVerified();
          if (isVerified) {
            if (!context.mounted) return;
            Utility.navigateMaterialRoute(context, RS6Screen());
          } else {
            if (!context.mounted) return;
            CustomToast.showToast(
              context,
              "Email not verified yet. Please check your inbox.",
              isError: true,
            );
          }
        }
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
    );
  }
}
