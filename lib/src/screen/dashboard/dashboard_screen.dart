import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<UserProvider>().fetchOwnProfile();
      context.read<ChildUserProvider>().fetchChildUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final childProvider = context.read<ChildUserProvider>();
    // Watch the UserProvider to get updates
    final userProvider = context.watch<UserProvider>();
    final UserModel? userInfo = userProvider.user;

    final bool isLoading = userProvider.status == DataFetchStatus.loading;
    final bool hasData = userInfo != null;

    logger.d('DashboardScreen: hasData: $hasData, isLoading: $isLoading');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (index, value) {
        doubleTapTrigger();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(title: 'Dashboard'),
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : !hasData
                  ? const Center(child: Text('Failed to load user data'))
                  : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userInfo.fullName ?? ''}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        CustomMaterialButton(
                          label: 'Logout',
                          onTap: () {
                            AuthProviderType type = AuthProviderType.email;
                            final loginType = userInfo.authProvider;
                            if (loginType == AuthProviderType.google.name) {
                              type = AuthProviderType.google;
                            } else if (loginType ==
                                AuthProviderType.facebook.name) {
                              type = AuthProviderType.facebook;
                            }
                            Utility.authWiseLogout(context, type);
                            Utility.navigate(context, AppRoutes.loginScreen);
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
                        const SizedBox(height: 24),
                        Text(
                          'Children:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (childProvider.childUser.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No children found.'),
                          )
                        else
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: childProvider.childUser.length,
                              itemBuilder: (context, index) {
                                final child = childProvider.childUser[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      child.avatarUrl,
                                    ),
                                  ),
                                  title: Text(child.fullName),
                                  subtitle: Text('DOB: ${child.dob}'),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
