import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;
    notifyListeners();
  }
}
