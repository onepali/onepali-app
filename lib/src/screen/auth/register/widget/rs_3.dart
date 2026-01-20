import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class RS3Screen extends StatefulWidget {
  const RS3Screen({super.key});

  @override
  State<RS3Screen> createState() => _RS3ScreenState();
}

class _RS3ScreenState extends State<RS3Screen> {
  final TextEditingController nameController = TextEditingController();
  DateTime selectedYear = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _player = AudioPlayer();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    _player.dispose();
    super.dispose();
  }

  void onYearSelected(DateTime date) {
    setState(() {
      selectedYear = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double titleBottomGap = isTabletPortrait ? 32.0 : 24.0;
    final double fieldGap = isTabletPortrait ? 24.0 : 20.0;
    final double infoTopGap = isTabletPortrait ? 8.0 : 5.0;
    final double titlePadding = isTabletPortrait ? 12.0 : 8.0;
    final double buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final double buttonRadius = isTabletPortrait ? 12.0 : 8.0;

    final TextStyle titleStyle = isTabletPortrait
        ? AppStyles.text24PxSemiBold
        : AppStyles.text20PxSemiBold;
    final TextStyle buttonTextStyle = isTabletPortrait
        ? AppStyles.text20PxMedium
        : AppStyles.text16PxMedium;
    final TextStyle titleActionTextStyle = isTabletPortrait
        ? AppStyles.text18PxSemiBold
        : AppStyles.text14PxSemiBold;

    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 3),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create your account', style: titleStyle),
              Gaps.verticalGapOf(titleBottomGap),
              TitleActionChild(
                titlePadding: EdgeInsets.only(bottom: titlePadding),
                title: 'Name',
                titleStyle: titleActionTextStyle,
                child: CustomTextField(
                  hintText: 'Enter your Full Name',
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  validation: (value) => Validator.name(value ?? ""),
                ),
              ),
              Gaps.verticalGapOf(fieldGap),
              TitleActionChild(
                title: 'Year of Birth',
                titleStyle: titleActionTextStyle,

                titlePadding: EdgeInsets.only(bottom: titlePadding),
                child: CupertinoDatePickerField(
                  initialDate: selectedYear,
                  onDateChanged: onYearSelected,
                  showMonth: false,
                  showDay: false,
                  validator: (date) {
                    final now = DateTime.now();
                    final minYear = now.year - 18;
                    if (date.year > minYear) {
                      return 'Parent must be at least 18 years old.';
                    }
                    return null;
                  },
                ),
              ),
              Gaps.verticalGapOf(infoTopGap),
              InfoWidget.info(
                'It will be the password for the parent zone.',
                isTablet: isTabletPortrait,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16.0,
          ),
          child: _buildNextButton(
            context,
            isTabletPortrait,
            buttonTextStyle,
            buttonHeight,
            buttonRadius,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    bool isTabletPortrait,
    TextStyle buttonTextStyle,
    double buttonHeight,
    double buttonRadius,
  ) {
    return CustomMaterialButton(
      label: 'Next',
      onTap: () {
        if (_formKey.currentState!.validate()) {
          
          // Save fullName and yearOfBirth to AuthState
          final authState = context.read<AuthState>();
          authState.setFullName(nameController.text.trim());
          authState.setYearOfBirth(selectedYear.year.toInt());
          Utility.navigate(context, AppRoutes.rs4Screen);
        }
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      textStyle: buttonTextStyle,
      height: buttonHeight,
      radius: buttonRadius,
      elevation: 0,
    );
  }
}
