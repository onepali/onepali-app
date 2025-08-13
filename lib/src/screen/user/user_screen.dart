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

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', centerTitle: false),
      backgroundColor: AppColors.kWhite,
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleActionChild(
                titlePadding: EdgeInsets.only(bottom: 8),
                title: 'Name',
                child: CustomTextField(
                  hintText: 'Enter your Full Name',
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  validation: (value) => Validator.name(value ?? ""),
                ),
              ),
              Gaps.verticalGapOf(20),
              TitleActionChild(
                titlePadding: EdgeInsets.only(bottom: 8),
                title: 'Email',
                child: CustomTextField(
                  hintText: 'Enter your Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  prefixIcon: Icon(Icons.email_outlined),
                  validation: (value) => Validator.email(value ?? ""),
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
