import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class ThemeViewModel extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeViewModel() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await _storageService.getDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
