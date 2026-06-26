import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_strings.dart';
import 'core/di/di.dart';
import 'core/utils/services/prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local storage
  await Hive.initFlutter();
  await Hive.openBox<Map>(AppConstants.bookingsBox);
  await Hive.openBox<String>(AppConstants.settingsBox);

  // Shared preferences (theme)
  await Prefs.init();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const ProviderScope(child: RitualBookingApp()));
}

class RitualBookingApp extends ConsumerWidget {
  const RitualBookingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
