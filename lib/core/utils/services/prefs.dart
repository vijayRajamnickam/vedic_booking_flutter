import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

class Prefs {
  Prefs._();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String getThemeMode() =>
      _prefs.getString(AppConstants.themeKey) ?? 'system';

  static Future<void> setThemeMode(String mode) =>
      _prefs.setString(AppConstants.themeKey, mode);

  static bool getOnboardingDone() =>
      _prefs.getBool(AppConstants.onboardingKey) ?? false;

  static Future<void> setOnboardingDone() =>
      _prefs.setBool(AppConstants.onboardingKey, true);
}
