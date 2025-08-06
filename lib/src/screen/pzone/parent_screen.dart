import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../src.dart';

class ParentZoneScreen extends StatefulWidget {
  final bool fromScreenTimeLimit;

  const ParentZoneScreen({super.key, this.fromScreenTimeLimit = false});

  @override
  State<ParentZoneScreen> createState() => _ParentZoneScreenState();
}

class _ParentZoneScreenState extends State<ParentZoneScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isError = false;
  bool _isLoading = false;
  bool _listenerAdded = false;
  final SharedPreferencesService sharedPref = SharedPreferencesService();

  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().fetchOwnProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_listenerAdded) {
      _pinController.addListener(() {
        if (_pinController.text.length == 4 && !_isLoading && !_isError) {
          _onPinCompleted(_pinController.text);
        }
      });
      _listenerAdded = true;
    }
  }

  void _onPinCompleted(String value) async {
    if (value.length != 4) return;
    setState(() => _isLoading = true);
    final userProvider = context.read<UserProvider>();
    final pin = int.tryParse(value);
    if (pin == null) {
      _showError();
      return;
    }
    final matched = await userProvider.isMatchedPin(pin);
    if (matched) {
      if (mounted) {
        ParentLocalStorage.setParentLogged(true);

        if (widget.fromScreenTimeLimit) {
          _navigateToChildUserScreen();
        } else {
          Utility.navigate(context, AppRoutes.parentDashboardScreen);
        }
      }
    } else {
      _showError();
    }
    setState(() => _isLoading = false);
  }

  void _showError() async {
    setState(() => _isError = true);
    // Vibrate (if available)
    try {
      // ignore: deprecated_member_use
      // Vibration.vibrate(duration: 100); // Uncomment if vibration package is used
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 300));
    _pinController.clear();
    setState(() => _isError = false);
  }

  void _navigateToChildUserScreen() async {
    final childProvider = context.read<ChildUserProvider>();

    // Fetch child users if not already loaded
    if (childProvider.childUser.isEmpty) {
      await childProvider.fetchChildUser();
    }

    // Get the current child
    final currentChild = await childProvider.getCurrentChild();

    if (currentChild != null && mounted) {
      Utility.navigateMaterialRoute(
        context,
        CUserScreen(
          child: currentChild,
          isFromScreenTimeLimit: widget.fromScreenTimeLimit,
        ),
        routeName: AppRoutes.childProfileScreen,
      );
    } else {
      // If no current child, just proceed with the normal PIN flow
      logger.w('No current child found, proceeding with PIN entry');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    return PopScope(
      canPop: !widget.fromScreenTimeLimit,
      onPopInvokedWithResult: (didPop, result) {
        if (widget.fromScreenTimeLimit && !didPop) {
          UserAppBar.setTabIndex(0);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => DashboardScreen(),
              settings: RouteSettings(name: AppRoutes.dashboardScreen),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.kPurple,
        body: SafeArea(
          child: Stack(
            children: [
              if (isTablet)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32, bottom: 16),
                    child: CustomImage(
                      Assets.parentZoneImage,
                      imageType: CustomImageType.local,
                      width: MediaQuery.of(context).size.width * 0.45,
                      boxFit: BoxFit.contain,
                    ),
                  ),
                ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Parents only',
                        style: AppStyles.text40PxBold.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gaps.verticalGapOf(16),
                      Text(
                        'Enter your year of birth',
                        style: AppStyles.text20PxRegular.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gaps.verticalGapOf(32),
                      CustomPinput(
                        length: 4,
                        controller: _pinController,
                        boxSize: 56,
                        boxSpacing: 16,
                        activeColor: AppColors.kWhite,
                        inactiveColor: Colors.white.withValues(alpha: 0.3),
                        errorColor: AppColors.kRed,
                        validator: (val) => _isError ? 'Invalid PIN' : null,
                      ),
                      Gaps.verticalGapOf(32),
                      if (_isLoading)
                        const CircularProgressIndicator(
                          color: AppColors.kWhite,
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 24,
                right: 24,
                child: GestureDetector(
                  onTap: () {
                    if (widget.fromScreenTimeLimit) {
                      logger.i(
                        '🚪 Exiting app from parent screen (from screen time limit)',
                      );
                      UserAppBar.setTabIndex(0);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => DashboardScreen(),
                          settings: RouteSettings(
                            name: AppRoutes.dashboardScreen,
                          ),
                        ),
                      );
                    } else {
                      // Regular navigation back
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
