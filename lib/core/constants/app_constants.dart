class AppConstants {
  AppConstants._();

  // Hive box names
  static const String bookingsBox = 'bookings_box';
  static const String settingsBox = 'settings_box';

  // SharedPreferences keys
  static const String themeKey = 'theme_mode';
  static const String onboardingKey = 'onboarding_done';

  // Mock OTP for demo
  static const String mockOtp = '1234';

  // Animation durations
  static const int splashDurationMs = 3000;
  static const int fadeAnimationMs = 800;
  static const int pageTransitionMs = 350;

  // Pagination
  static const int pageSize = 20;

  // Bottom nav indices
  static const int homeIndex = 0;
  static const int bookingsIndex = 1;
  static const int earningsIndex = 2;
  static const int profileIndex = 3;
}
