import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final sharedPref = SharedPreferencesService();
    final userInfoJson = await sharedPref.getStringPref(AppConstants.userInfo);
    if (userInfoJson != null) {
      setState(() {
        userInfo = jsonDecode(userInfoJson);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Dashboard'),
        body:
            userInfo == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                          userInfo!['user_dp'] ?? '',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userInfo!['email'] ?? ''}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      CustomMaterialButton(
                        label: 'Logout',
                        onTap: () {
                          AuthProviderType type = AuthProviderType.email;
                          final loginType = userInfo!['login_type'];
                          if (loginType == AuthProviderType.google.name) {
                            type = AuthProviderType.google;
                          } else if (loginType ==
                              AuthProviderType.facebook.name) {
                            type = AuthProviderType.facebook;
                          }
                          Utility.authWiseLogout(context, type);
                        },
                        width: 100,
                        height: 40,
                      ),
                      const SizedBox(height: 16),
                      CustomTextButton(
                        text: 'Create Child',
                        onPressed: () {
                          Utility.navigateMaterialRoute(
                            context,
                            ChildRegisterScreen(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
