import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:provider/provider.dart';

import '../../src.dart';

class ParentZoneScreen extends StatefulWidget {
  final bool fromScreenTimeLimit;
  final String? childId;
  final bool fromAddChild;

  const ParentZoneScreen({
    super.key,
    this.fromScreenTimeLimit = false,
    this.childId,
    this.fromAddChild = false,
  });

  @override
  State<ParentZoneScreen> createState() => _ParentZoneScreenState();
}

class _ParentZoneScreenState extends State<ParentZoneScreen> {
  final TextEditingController _passcodeController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _resetController = TextEditingController();

  PasscodeScreenState _screenState = PasscodeScreenState.loading;
  bool _isError = false;
  bool _isLoading = false;
  bool _listenerAdded = false;
  String? _errorMessage;
  String? _enteredPasscode;

  final SharedPreferencesService sharedPref = SharedPreferencesService();

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      _initializeScreen();
    });
  }

  Future<void> _initializeScreen() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.fetchOwnProfile();

    // Check if user has an existing passcode
    final hasPasscode = await userProvider.hasPasscode();

    setState(() {
      _screenState = hasPasscode
          ? PasscodeScreenState.enterPasscode
          : PasscodeScreenState.setNewPasscode;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_listenerAdded) {
      _setupControllerListeners();
      _listenerAdded = true;
    }
  }

  void _setupControllerListeners() {
    _passcodeController.addListener(() {
      final length = AppConstants.passcodeDefaultLength;
      if (_passcodeController.text.length == length &&
          !_isLoading &&
          !_isError) {
        _handlePasscodeCompleted(_passcodeController.text);
      }
    });

    _confirmController.addListener(() {
      final length = AppConstants.passcodeDefaultLength;
      if (_confirmController.text.length == length &&
          !_isLoading &&
          !_isError &&
          (_screenState == PasscodeScreenState.confirmPasscode ||
              _screenState == PasscodeScreenState.resetConfirm)) {
        _handleConfirmCompleted(_confirmController.text);
      }
    });

    // Reset (birth year) listener
    _resetController.addListener(() {
      if (_resetController.text.length == 4 &&
          !_isLoading &&
          !_isError &&
          _screenState == PasscodeScreenState.resetPasscode) {
        _handleResetCompleted(_resetController.text);
      }
    });
  }

  // ===== PASSCODE HANDLERS =====

  void _handlePasscodeCompleted(String value) async {
    switch (_screenState) {
      case PasscodeScreenState.setNewPasscode:
        _enteredPasscode = value;
        _passcodeController.clear();
        _confirmController.clear();
        setState(() {
          _screenState = PasscodeScreenState.confirmPasscode;
        });
        break;

      case PasscodeScreenState.enterPasscode:
        await _verifyPasscode(value);
        break;

      case PasscodeScreenState.resetSetNew:
        _enteredPasscode = value;
        _passcodeController.clear();
        _confirmController.clear();
        setState(() {
          _screenState = PasscodeScreenState.resetConfirm;
        });
        break;

      default:
        break;
    }
  }

  void _handleConfirmCompleted(String value) async {
    if (_enteredPasscode == null) return;

    if (value == _enteredPasscode) {
      await _saveNewPasscode(_enteredPasscode!);
    } else {
      _showError('Passcodes do not match. Please try again.');
      setState(() {
        _screenState = _screenState == PasscodeScreenState.resetConfirm
            ? PasscodeScreenState.resetSetNew
            : PasscodeScreenState.setNewPasscode;
      });
      _passcodeController.clear();
      _confirmController.clear();
      _enteredPasscode = null;
    }
  }

  void _handleResetCompleted(String value) async {
    final yearOfBirth = int.tryParse(value);
    if (yearOfBirth == null) {
      _showError('Please enter a valid year.');
      return;
    }

    setState(() => _isLoading = true);

    final userProvider = context.read<UserProvider>();
    final success = await userProvider.resetPasscodeWithBirth(yearOfBirth);

    setState(() => _isLoading = false);

    if (success) {
      setState(() {
        _screenState = PasscodeScreenState.resetSetNew;
      });
      _resetController.clear();
      _passcodeController.clear();
    } else {
      _showError('Invalid year of birth. Please try again.');
      _resetController.clear();
    }
  }

  Future<void> _verifyPasscode(String passcode) async {
    setState(() => _isLoading = true);

    final userProvider = context.read<UserProvider>();
    final result = await userProvider.verifyPasscode(passcode);

    setState(() => _isLoading = false);

    if (result.isSuccess) {
      _handleSuccessfulVerification();
    } else if (result.isLocked) {
      _showError(_getLockoutMessage(result.lockDuration));
    } else if (result.hasError) {
      _showError(result.errorMessage ?? 'An error occurred. Please try again.');
    } else {
      final remaining = result.attemptsRemaining ?? 0;
      _showError('Invalid passcode. $remaining attempts remaining.');
    }

    _passcodeController.clear();
  }

  Future<void> _saveNewPasscode(String passcode) async {
    setState(() => _isLoading = true);

    final userProvider = context.read<UserProvider>();
    final success = await userProvider.createPasscode(passcode);

    setState(() => _isLoading = false);

    if (success) {
      _handleSuccessfulVerification();
    } else {
      _showError('Failed to save passcode. Please try again.');
      setState(() {
        _screenState = PasscodeScreenState.setNewPasscode;
      });
      _passcodeController.clear();
      _confirmController.clear();
      _enteredPasscode = null;
    }
  }

  void _handleSuccessfulVerification() async {
    if (mounted) {
      if (widget.fromScreenTimeLimit) {
        Utility.navigate(
          context,
          AppRoutes.extendTimeScreen,
          arguments: {'childId': widget.childId},
        );
      } else if (widget.fromAddChild) {
        Utility.navigate(context, AppRoutes.childRegisterScreen);
      } else {
        // Ensure isParentLogged is set and persisted before navigation
        await ParentLocalStorage.setParentLogged(true);
        if (mounted) {
          Utility.navigate(context, AppRoutes.parentDashboardScreen);
        }
      }
    }
  }

  String _getLockoutMessage(Duration? lockDuration) {
    if (lockDuration == null) return 'Account is temporarily locked.';

    final minutes = lockDuration.inMinutes;
    final seconds = lockDuration.inSeconds % 60;

    if (minutes > 0) {
      return 'Account locked for ${minutes}m ${seconds}s. Please try again later.';
    } else {
      return 'Account locked for ${seconds}s. Please try again later.';
    }
  }

  String _getSubtitleText() {
    switch (_screenState) {
      case PasscodeScreenState.loading:
        return 'Loading...';
      case PasscodeScreenState.setNewPasscode:
        return 'Create a 4-digit passcode';
      case PasscodeScreenState.confirmPasscode:
        return 'Confirm your passcode';
      case PasscodeScreenState.enterPasscode:
        return 'Enter your passcode';
      case PasscodeScreenState.resetPasscode:
        return 'Enter your year of birth to reset';
      case PasscodeScreenState.resetSetNew:
        return 'Create a new 4-digit passcode';
      case PasscodeScreenState.resetConfirm:
        return 'Confirm your new passcode';
    }
  }

  TextEditingController _getCurrentController() {
    switch (_screenState) {
      case PasscodeScreenState.setNewPasscode:
      case PasscodeScreenState.enterPasscode:
      case PasscodeScreenState.resetSetNew:
        return _passcodeController;
      case PasscodeScreenState.confirmPasscode:
      case PasscodeScreenState.resetConfirm:
        return _confirmController;
      case PasscodeScreenState.resetPasscode:
        return _resetController;
      default:
        return _passcodeController;
    }
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    _confirmController.dispose();
    _resetController.dispose();
    super.dispose();
  }

  void _showError([String? message]) async {
    setState(() {
      _isError = true;
      _errorMessage = message;
    });

    try {} catch (_) {}

    await Future.delayed(const Duration(milliseconds: 300));

    switch (_screenState) {
      case PasscodeScreenState.setNewPasscode:
      case PasscodeScreenState.resetSetNew:
      case PasscodeScreenState.enterPasscode:
        _passcodeController.clear();
        break;
      case PasscodeScreenState.confirmPasscode:
      case PasscodeScreenState.resetConfirm:
        _confirmController.clear();
        break;
      case PasscodeScreenState.resetPasscode:
        _resetController.clear();
        break;
      default:
        break;
    }

    setState(() {
      _isError = false;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    return PopScope(
      canPop: !widget.fromScreenTimeLimit && !widget.fromAddChild,
      onPopInvokedWithResult: (didPop, result) {
        if ((widget.fromScreenTimeLimit || widget.fromAddChild) && !didPop) {
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
        body: Stack(
          children: [
            if (isTablet)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: CustomImage(
                    Assets.parentZoneImage,
                    imageType: CustomImageType.local,
                    width: MediaQuery.of(context).size.width * 0.6,
                    boxFit: BoxFit.contain,
                  ),
                ),
              ),
            Align(
              alignment: !isTablet ? Alignment.center : Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isTablet) Gaps.verticalGapOf(80),
                    Text(
                      'Parents only',
                      style: AppStyles.text40PxBold.copyWith(
                        color: AppColors.kWhite,
                        fontSize: isTablet ? 52 : 40,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gaps.verticalGapOf(16),
                    Text(
                      _getSubtitleText(),
                      style: AppStyles.text20PxRegular.copyWith(
                        color: AppColors.kWhite,
                        fontSize: isTablet ? 24 : 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gaps.verticalGapOf(32),
                    CustomPinput(
                      key: ValueKey(_screenState),
                      length: AppConstants.passcodeDefaultLength,
                      controller: _getCurrentController(),
                      boxSize: isTablet ? 70 : 56,
                      boxSpacing: 16,
                      activeColor: AppColors.kWhite,
                      inactiveColor: AppColors.kWhite.withValues(alpha: 0.3),
                      errorColor: AppColors.kRed,
                      validator: (val) => _isError
                          ? (_errorMessage ?? 'Invalid input')
                          : null,
                    ),
                    Gaps.verticalGapOf(32),
                    if (_isLoading)
                      const CircularProgressIndicator(
                        color: AppColors.kWhite,
                      ),
                    if (_screenState == PasscodeScreenState.enterPasscode &&
                        !_isLoading)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _screenState = PasscodeScreenState.resetPasscode;
                          });
                          _passcodeController.clear();
                        },
                        child: Text(
                          'Forgot passcode?',
                          style: AppStyles.text16PxRegular.copyWith(
                            color: AppColors.kWhite.withValues(alpha: 0.8),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            TopRightPositionedCloseButton(
              iconPath: Assets.closeGreyIcon,
              onTap: () {
                if (widget.fromScreenTimeLimit || widget.fromAddChild) {
                  logger.i(
                    'Exiting app from parent screen (from screen time limit or add child)',
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
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
