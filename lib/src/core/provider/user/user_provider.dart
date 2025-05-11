import 'package:flutter/material.dart';
import '../../../src.dart';

class UserProvider extends ChangeNotifier {
  final UserRepo _userRepo = UserRepo();
  DataFetchStatus _status = DataFetchStatus.initial;
  UserModel? _user;

  DataFetchStatus get status => _status;
  UserModel? get user => _user;

  Future<void> userProfile(
    BuildContext context,
    String email,
    String password,
  ) async {
    _status = DataFetchStatus.loading;
    notifyListeners();

    final response = await _userRepo.user();

    if (response.status) {
      _user = response.data as UserModel;

      _status = DataFetchStatus.success;
      notifyListeners();
    } else {
      _status = DataFetchStatus.error;
      notifyListeners();

      if (!context.mounted) return;
    }
  }
}
