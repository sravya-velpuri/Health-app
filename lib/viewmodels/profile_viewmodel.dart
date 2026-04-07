import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  static const String _nameKey = 'profile_name';
  static const String _ageKey = 'profile_age';
  static const String _heightKey = 'profile_height';
  static const String _weightKey = 'profile_weight';
  static const String _genderKey = 'profile_gender';
  static const String _goalKey = 'profile_goal';
  static const String _imagePathKey = 'profile_image_path';
  static const String _languageKey = 'profile_language';

  String _name = '';
  String _age = '';
  String _height = '';
  String _weight = '';
  String _gender = 'Male';
  String _goal = 'Stay Healthy';
  String _language = 'English';
  String? _imagePath;

  String get name => _name;
  String get age => _age;
  String get height => _height;
  String get weight => _weight;
  String get gender => _gender;
  String get goal => _goal;
  String get language => _language;
  String? get imagePath => _imagePath;

  ProfileViewModel() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString(_nameKey) ?? '';
    _age = prefs.getString(_ageKey) ?? '';
    _height = prefs.getString(_heightKey) ?? '';
    _weight = prefs.getString(_weightKey) ?? '';
    _gender = prefs.getString(_genderKey) ?? 'Male';
    _goal = prefs.getString(_goalKey) ?? 'Stay Healthy';
    _language = prefs.getString(_languageKey) ?? 'English';
    _imagePath = prefs.getString(_imagePathKey);
    notifyListeners();
  }

  Future<void> saveProfile({
    required String name,
    required String age,
    required String height,
    required String weight,
    required String gender,
    required String goal,
    required String language,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_ageKey, age);
    await prefs.setString(_heightKey, height);
    await prefs.setString(_weightKey, weight);
    await prefs.setString(_genderKey, gender);
    await prefs.setString(_goalKey, goal);
    await prefs.setString(_languageKey, language);
    _name = name;
    _age = age;
    _height = height;
    _weight = weight;
    _gender = gender;
    _goal = goal;
    _language = language;
    notifyListeners();
  }

  Future<void> updateImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imagePathKey, path);
    _imagePath = path;
    notifyListeners();
  }
}
