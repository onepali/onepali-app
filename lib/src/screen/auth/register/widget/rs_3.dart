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
      selectedYear = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 3),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create your Account', style: AppStyles.text20PxSemiBold),
              SizedBox(height: 24),
              TitleActionChild(
                titlePadding: EdgeInsets.only(bottom: 8),
                title: 'Name',
                child: CustomTextField(
                  hintText: 'Enter your Full Name',
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  validation: (value) => Validator.empty(value ?? ""),
                ),
              ),
              Gaps.verticalGapOf(20),
              TitleActionChild(
                title: 'Year of Birth',
                titlePadding: EdgeInsets.only(bottom: 8),
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
              Gaps.verticalGapOf(5),
              InfoWidget.info('It will be the password for the parent zone.'),
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
      onTap: () {
        if (_formKey.currentState!.validate()) {
          // Save fullName and yearOfBirth to AuthState
          final authState = context.read<AuthState>();
          authState.setFullName(nameController.text.trim());
          authState.setYearOfBirth(selectedYear.year.toInt());
          Utility.navigateMaterialRoute(context, RS4Screen());
        }
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
    );
  }
}
