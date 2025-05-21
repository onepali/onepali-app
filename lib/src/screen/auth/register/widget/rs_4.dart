import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class RS4Screen extends StatefulWidget {
  const RS4Screen({super.key});

  @override
  State<RS4Screen> createState() => _RS4ScreenState();
}

class _RS4ScreenState extends State<RS4Screen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 4),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create your Account', style: AppStyles.text20PxSemiBold),
            SizedBox(height: 24),
            TitleActionChild(
              titlePadding: EdgeInsets.only(bottom: 8),

              title: 'Email',
              child: CustomTextField(
                hintText: 'Enter your Email Address',
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            Gaps.verticalGapOf(20),
            TitleActionChild(
              title: 'Password',

              titlePadding: EdgeInsets.only(bottom: 8),
              child: CustomTextField(
                hintText: 'Enter a Password',
                isPasswordField: isObscure,
                controller: passwordController,
                prefixIcon: Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    !isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            Gaps.verticalGapOf(50),
            Utility.horizontalDividerTitle(),
            Gaps.verticalGapOf(20),
            ReusableWidget.horizontalIconTitle(title: 'Continue with Google'),
            Gaps.verticalGapOf(15),

            ReusableWidget.horizontalIconTitle(
              title: 'Continue with Facebook',
              icon: Assets.facebook,
            ),
            Spacer(),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return CustomMaterialButton(
      label: 'Next',
      onTap: () {
        Utility.navigateMaterialRoute(context, RS5Screen());
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
    );
  }
}
