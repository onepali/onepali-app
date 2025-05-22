import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

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
                  child: Row(
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
                            userInfo!['full_name'] ?? '',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Login type: ${userInfo!['login_type'] ?? ''}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      CustomMaterialButton(
                        label: 'Logout',
                        onTap: () {
                          final authProvider =
                              context.read<GoogleAuthProvider>();
                          authProvider.signOut(context);
                        },
                        width: 100,
                        height: 40,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
