import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class ChildRegisterScreen extends StatefulWidget {
  const ChildRegisterScreen({super.key});

  @override
  State<ChildRegisterScreen> createState() => _ChildRegisterScreenState();
}

class _ChildRegisterScreenState extends State<ChildRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  onYearSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double titleBottomGap = isTabletPortrait ? 32.0 : 24.0;
    final double fieldGap = isTabletPortrait ? 32.0 : 20.0;
    final double buttonTopGap = isTabletPortrait ? 32.0 : 20.0;
    final double buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final double buttonRadius = isTabletPortrait ? 12.0 : 8.0;

    final TextStyle titleStyle =
        isTabletPortrait
            ? AppStyles.text24PxSemiBold
            : AppStyles.text20PxSemiBold;
    final TextStyle titleActionTextStyle =
        isTabletPortrait
            ? AppStyles.text18PxSemiBold
            : AppStyles.text14PxSemiBold;

    final TextStyle buttonTextStyle =
        isTabletPortrait ? AppStyles.text18PxMedium : AppStyles.text16PxMedium;

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showStepper: true,
        currentStep: 1,
        totalSteps: 5,
      ),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Personalize your Child Account', style: titleStyle),
                Gaps.verticalGapOf(titleBottomGap),
                TitleActionChild(
                  titlePadding: EdgeInsets.only(bottom: 8),
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
                  title: 'Birthday',
                  titleStyle: titleActionTextStyle,
                  titlePadding: EdgeInsets.only(bottom: 8),
                  child: CupertinoDatePickerField(
                    initialDate: selectedDate,
                    onDateChanged: onYearSelected,
                    maxYear: DateTime.now().year,
                    showMonth: true,
                    showDay: false,
                  ),
                ),
                // Gaps.verticalGapOf(5),
                // InfoWidget.info('It will be the password for the parent zone.'),
                Gaps.verticalGapOf(buttonTopGap),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            // bottom: isTabletPortrait ? 24.0 : 16.0,
            top: 0,
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
          final authState = context.read<AuthState>();
          authState.setChildName(nameController.text.trim());
          authState.setChildDob(selectedDate.toString());
          Utility.navigateMaterialRoute(
            context,
            ChildRS1Screen(),
            routeName: AppRoutes.childRS1Screen,
          );
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
