import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  DateTime selectedYear = DateTime.now();

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');

    // Set initial year - use user's yearOfBirth if available, otherwise a default
    if (user?.yearOfBirth != null && user!.yearOfBirth > 0) {
      selectedYear = DateTime(user.yearOfBirth);
    } else {
      selectedYear = DateTime(DateTime.now().year - 30);
    }
  }

  void onYearSelected(DateTime date) {
    setState(() {
      selectedYear = date;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Platform responsive variables
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 24.0;
    final double verticalGap1 = isTabletPortrait ? 24.0 : 20.0;
    final double verticalGap2 = isTabletPortrait ? 24.0 : 20.0;

    final TextStyle titleStyle = isTabletPortrait
        ? AppStyles.text18PxMedium
        : AppStyles.text16PxMedium;

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', centerTitle: false),
      backgroundColor: AppColors.kWhite,
      body: Container(
        padding: EdgeInsets.all(horizontalPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleActionChild(
                titlePadding: EdgeInsets.only(bottom: 8),
                title: 'Name',
                titleStyle: titleStyle,
                child: CustomTextField(
                  hintText: 'Enter your Full Name',
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  validation: (value) => Validator.name(value ?? ""),
                ),
              ),
              Gaps.verticalGapOf(verticalGap1),
              TitleActionChild(
                titlePadding: EdgeInsets.only(bottom: 8),
                title: 'Email',
                titleStyle: titleStyle,
                child: CustomTextField(
                  hintText: 'Enter your Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  prefixIcon: Icon(Icons.email_outlined),
                  validation: (value) => Validator.email(value ?? ""),
                ),
              ),
              Gaps.verticalGapOf(verticalGap2),
              TitleActionChild(
                title: 'Year of Birth',
                titleStyle: titleStyle,
                titlePadding: EdgeInsets.only(bottom: 8),
                child: CupertinoDatePickerField(
                  initialDate: selectedYear,
                  onDateChanged: onYearSelected,
                  maxYear: DateTime.now().year - 13,
                  minYear: 1900,
                  showMonth: false,
                  showDay: false,
                ),
              ),
              const Spacer(),
              CustomMaterialButton(
                label: 'Update',
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await context.read<UserProvider>().updateUserProfile(
                      fullName: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      yearOfBirth: selectedYear.year,
                    );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                backgroundColor: AppColors.kButtonGreen,
                width: double.infinity,
                elevation: 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
