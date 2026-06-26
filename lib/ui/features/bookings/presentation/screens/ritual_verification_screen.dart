import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/config/app_routes.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_strings.dart';
import '../provider/bookings_provider.dart';

class RitualVerificationScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const RitualVerificationScreen({super.key, required this.bookingId});

  @override
  ConsumerState<RitualVerificationScreen> createState() =>
      _RitualVerificationScreenState();
}

class _RitualVerificationScreenState
    extends ConsumerState<RitualVerificationScreen> {
  final _pinController = TextEditingController();
  bool _locationVerified = true;
  bool _materialsReady = true;
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_pinController.text.length < 4) {
      setState(() => _error = 'Please enter the 4-digit OTP');
      return;
    }
    if (_pinController.text != AppConstants.mockOtp) {
      setState(() => _error = AppStrings.invalidOtp);
      return;
    }
    setState(() {
      _error = null;
      _isLoading = true;
    });

    final ok = await ref.read(bookingsProvider).startRitual(widget.bookingId);
    if (!mounted) return;

    setState(() => _isLoading = false);
    if (ok) {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.ritualProgress,
        arguments: {'bookingId': widget.bookingId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(bookingsProvider);
    final booking = provider.getBookingById(widget.bookingId);

    return Scaffold(
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                children: [
                  // Ritual type card
                  if (booking != null) _RitualCard(booking: booking),
                  const SizedBox(height: 32),

                  // Verification code title
                  Text(
                    AppStrings.verificationCode,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.verificationSubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // OTP boxes
                  _OtpInput(
                    controller: _pinController,
                    error: _error,
                    onChanged: (_) => setState(() => _error = null),
                    onCompleted: (_) => _verify(),
                  ),

                  // Error
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _error!,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.cancelled),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Resend OTP — plain dark text link
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('OTP resent to devotee!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      AppStrings.resendOtp,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Checklist cards
                  Row(
                    children: [
                      _CheckCard(
                        label: AppStrings.locationVerified,
                        value: _locationVerified,
                        onTap: () => setState(
                            () => _locationVerified = !_locationVerified),
                      ),
                      const SizedBox(width: 12),
                      _CheckCard(
                        label: AppStrings.materialsReady,
                        value: _materialsReady,
                        onTap: () =>
                            setState(() => _materialsReady = !_materialsReady),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // CTA — pill-shaped
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isLoading ? null : _verify,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              AppStrings.verifyAndStart,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome,
                          color: AppColors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        AppStrings.bookingRegistry,
                        style: AppTextStyles.bodyMediumOnPrimary
                            .copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _HeaderIconBtn(icon: Icons.search),
                  const SizedBox(width: 10),
                  _HeaderIconBtn(
                      icon: Icons.notifications_outlined, hasBadge: true),
                ],
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                'Start Ritual',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final bool hasBadge;

  const _HeaderIconBtn({required this.icon, this.hasBadge = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.white, size: 20),
        ),
        if (hasBadge)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Ritual card ─────────────────────────────────────────────────────────────

class _RitualCard extends StatelessWidget {
  final dynamic booking;

  const _RitualCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Vedic logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/vedic_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.temple_hindu,
                  color: AppColors.gold,
                  size: 36,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.ritualType,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.service as String,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${booking.totalAmount}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── OTP input ────────────────────────────────────────────────────────────────

class _OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  const _OtpInput({
    required this.controller,
    required this.error,
    required this.onChanged,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF3B1FA0); // deep purple border like design

    final defaultTheme = PinTheme(
      width: 72,
      height: 72,
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDark,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 10,
          ),
        ],
      ),
    );

    final errorTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.cancelledSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cancelled, width: 2),
      ),
    );

    return Pinput(
      length: 4,
      controller: controller,
      defaultPinTheme: defaultTheme,
      focusedPinTheme: focusedTheme,
      errorPinTheme: errorTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
      showCursor: true,
      onChanged: onChanged,
      onCompleted: onCompleted,
    );
  }
}

// ─── Check card ───────────────────────────────────────────────────────────────

class _CheckCard extends StatelessWidget {
  final String label;
  final bool value;
  final VoidCallback onTap;

  const _CheckCard({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                value
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: value ? AppColors.primary : AppColors.textHint,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
