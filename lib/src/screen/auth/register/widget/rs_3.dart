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
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _nonTextFocusNode = FocusNode();
  DateTime selectedYear = DateTime.now();
  bool _hasSelectedYear = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    _nameFocusNode.dispose();
    _nonTextFocusNode.dispose();
    super.dispose();
  }

  void onYearSelected(DateTime date) {
    setState(() {
      selectedYear = date;
      _hasSelectedYear = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _clearInputFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double titleBottomGap = isTabletPortrait ? 56.0 : 44.0;
    final double fieldGap = isTabletPortrait ? 24.0 : 20.0;
    final double fieldHeight = isTabletPortrait ? 64.0 : 56.0;
    final double fieldVerticalPadding = isTabletPortrait ? 20.0 : 16.0;
    final double fieldLabelGap = isTabletPortrait ? 16.0 : 12.0;
    final double pencilSize = isTabletPortrait ? 96.0 : 76.0;
    final double buttonHeight = AuthOnboardingLayout.buttonHeight(context);
    final double buttonRadius = AuthOnboardingLayout.buttonRadius(context);
    final int maxParentBirthYear = DateTime.now().year - 18;

    final TextStyle titleStyle = isTabletPortrait
        ? AppStyles.text24PxSemiBold
        : AppStyles.text20PxSemiBold;
    final TextStyle buttonTextStyle = isTabletPortrait
        ? AppStyles.text20PxMedium
        : AppStyles.text16PxMedium;
    final TextStyle titleActionTextStyle = isTabletPortrait
        ? AppStyles.text18PxSemiBold
        : AppStyles.text14PxSemiBold;
    final double fieldLabelWidth =
        _textWidth(
          'Year of Birth',
          titleActionTextStyle,
          MediaQuery.textScalerOf(context),
        ).ceilToDouble() +
        fieldLabelGap;

    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 3),
      backgroundColor: AppColors.kWhite,
      body: AuthOnboardingLayout(
        body: Focus(
          focusNode: _nonTextFocusNode,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Create your account',
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Gaps.verticalGapOf(titleBottomGap),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: fieldHeight),
                  child: CustomTextField(
                    hintText: 'Enter your Full Name',
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    focusNode: _nameFocusNode,
                    prefixIcon: _fieldLabelPrefix(
                      'Name',
                      titleActionTextStyle,
                      fieldLabelWidth,
                      fieldLabelGap,
                      isTabletPortrait,
                    ),
                    paddingHorizontal: 0,
                    paddingVertical: fieldVerticalPadding,
                    validation: (value) => Validator.name(value ?? ""),
                  ),
                ),
                Gaps.verticalGapOf(fieldGap),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: fieldHeight),
                  child: CupertinoDatePickerField(
                    initialDate: selectedYear,
                    onDateChanged: onYearSelected,
                    label: 'Year of Birth',
                    labelWidth: fieldLabelWidth,
                    labelStyle: titleActionTextStyle.copyWith(
                      color: AppColors.kPitchBlack,
                    ),
                    labelGap: fieldLabelGap,
                    placeholder: 'It will be used as Parent Zone password',
                    maxYear: maxParentBirthYear,
                    selectOnPickerTap: true,
                    verticalPadding: fieldVerticalPadding,
                    showMonth: false,
                    showDay: false,
                    validator: (date) {
                      if (date.year > maxParentBirthYear) {
                        return 'Parent must be at least 18 years old.';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SvgHelper.fromSource(
                      path: Assets.pencil,
                      height: pencilSize,
                      width: pencilSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomAction: _buildNextButton(
          context,
          isTabletPortrait,
          buttonTextStyle,
          buttonHeight,
          buttonRadius,
        ),
      ),
    );
  }

  void _clearInputFocus() {
    _nameFocusNode.unfocus();
    FocusScope.of(context).requestFocus(_nonTextFocusNode);
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
          if (!_hasSelectedYear) {
            showCustomToaster(
              'Please select your year of birth.',
              isError: true,
            );
            return;
          }
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

  Widget _fieldLabelPrefix(
    String label,
    TextStyle textStyle,
    double labelWidth,
    double labelGap,
    bool isTabletPortrait,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: isTabletPortrait ? 16.0 : 12.0,
        right: labelGap,
      ),
      child: Align(
        widthFactor: 1,
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: textStyle.copyWith(color: AppColors.kPitchBlack),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  double _textWidth(String text, TextStyle style, TextScaler textScaler) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout();
    return textPainter.width;
  }
}
