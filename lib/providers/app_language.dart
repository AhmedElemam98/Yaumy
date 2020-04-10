import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage with ChangeNotifier {
  String _currentLanguage;
  bool _isChoseLanguage = false;

  String get currentLanguage {
    return _currentLanguage;
  }

  bool get isChoseLanguage {
    return _isChoseLanguage;
  }

  void setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('app_language', language);
    _currentLanguage = language;
    _isChoseLanguage = true;
    notifyListeners();
  }

  Future<bool> reGetLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('app_language')) {
      return false;
    } else {
      _currentLanguage = prefs.getString('app_language');
      _isChoseLanguage = true;
      return true;
    }
  }
}
