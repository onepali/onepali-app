import 'package:flutter/material.dart';

import '../../src.dart';

class RewardProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  List<RewardModel> _rewards = [];
  List<RewardModel> get rewards => _rewards;

  setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }
}
