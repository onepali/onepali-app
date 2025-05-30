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
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showStepper: true,
        currentStep: 1,
        totalSteps: 4,
      ),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personalize your\nChild Account',
                  style: AppStyles.text20PxSemiBold,
                ),
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
                  title: 'Birthday',
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
                SizedBox(height: 20),
                _buildNextButton(context),
              ],
            ),
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
          final authState = context.read<AuthState>();
          authState.setChildName(nameController.text.trim());
          authState.setChildDob(selectedDate.toString());
          Utility.navigateMaterialRoute(context, ChildRS1Screen());
        }
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
    );
  }
}
