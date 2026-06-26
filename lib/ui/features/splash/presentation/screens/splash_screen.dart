import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/config/app_routes.dart';
import '../../../../../core/config/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.splashDurationMs),
    );
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.shell);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo circle
              Container(
                width: 210,
                height: 210,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/vedic_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.6, 0.6),
                    duration: 800.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 32),

              // Tagline
              Text(
                AppStrings.tagline,
                style: AppTextStyles.bodyMediumOnPrimary.copyWith(fontSize: 15),
                textAlign: TextAlign.center,
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const Spacer(flex: 2),

              // Get Started button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: _GradientButton(
                  label: AppStrings.getStarted,
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed(AppRoutes.shell),
                ),
              )
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.4, end: 0),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.buttonGradientStart, AppColors.buttonGradientEnd],
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.getStarted,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: AppColors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
