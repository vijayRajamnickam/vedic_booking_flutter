import 'package:flutter/material.dart';
import '../../ui/features/splash/presentation/screens/splash_screen.dart';
import '../../ui/features/bookings/presentation/screens/booking_details_screen.dart';
import '../../ui/features/bookings/presentation/screens/ritual_verification_screen.dart';
import '../../ui/features/bookings/presentation/screens/ritual_progress_screen.dart';
import '../../ui/features/profile/presentation/screens/subscription_screen.dart';
import '../../ui/features/main_shell.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String shell = '/shell';
  static const String bookingDetails = '/booking-details';
  static const String ritualVerification = '/ritual-verification';
  static const String ritualProgress = '/ritual-progress';
  static const String subscription = '/subscription';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        shell: (_) => const MainShell(),
        bookingDetails: (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments
              as Map<String, dynamic>;
          return BookingDetailsScreen(bookingId: args['bookingId'] as String);
        },
        ritualVerification: (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments
              as Map<String, dynamic>;
          return RitualVerificationScreen(bookingId: args['bookingId'] as String);
        },
        ritualProgress: (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments
              as Map<String, dynamic>;
          return RitualProgressScreen(bookingId: args['bookingId'] as String);
        },
        subscription: (_) => const SubscriptionScreen(),
      };

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => const MainShell());
  }

  // Smooth slide transition used when opening booking details
  static Route<T> slideUpRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, animation, secondary) => page,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (_, animation, secondary, child) {
        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
