import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../data/model/booking_model.dart';
import '../provider/bookings_provider.dart';

class RitualProgressScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const RitualProgressScreen({super.key, required this.bookingId});

  @override
  ConsumerState<RitualProgressScreen> createState() =>
      _RitualProgressScreenState();
}

class _RitualProgressScreenState extends ConsumerState<RitualProgressScreen> {
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _elapsed {
    final h = _elapsedSeconds ~/ 3600;
    final m = (_elapsedSeconds % 3600) ~/ 60;
    final s = _elapsedSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  Future<void> _endRitual() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.confirmEndRitual),
        content: const Text(AppStrings.confirmEndRitualMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final ok = await ref
                  .read(bookingsProvider)
                  .endRitual(widget.bookingId);
              if (ok && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppStrings.ritualCompleted),
                    backgroundColor: AppColors.completed,
                  ),
                );
                // Pop back to main shell
                Navigator.of(context)
                  ..pop()
                  ..pop();
              }
            },
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingsProvider).getBookingById(widget.bookingId);

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ritual in Progress')),
        body: const Center(child: Text('Booking not found')),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _ProgressHeader(booking: booking),
          // Live elapsed timer
          _ElapsedTimer(elapsed: _elapsed),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                children: [
                  _InfoCard(
                    title: AppStrings.customerDetails,
                    icon: Icons.person_outline,
                    booking: booking,
                  ),
                  const SizedBox(height: 16),
                  _BookingCard(booking: booking),
                ],
              ),
            ),
          ),
          // End Ritual CTA
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _endRitual,
                  child: Text(
                    AppStrings.endRitual,
                    style: TextStyle(fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final BookingModel booking;

  const _ProgressHeader({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${booking.id} • ${booking.date}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    booking.service,
                    style: AppTextStyles.headlineLarge
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ElapsedTimer extends StatelessWidget {
  final String elapsed;

  const _ElapsedTimer({required this.elapsed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.gold, size: 24),
          const SizedBox(width: 12),
          Column(
            children: [
              Text(
                AppStrings.elapsedTime,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.white.withValues(alpha: 0.7)),
              ),
              Text(
                elapsed,
                style: TextStyle(fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final BookingModel booking;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    Color avatarColor;
    try {
      avatarColor = Color(int.parse(booking.customerAvatarColor));
    } catch (_) {
      avatarColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: avatarColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    booking.customerInitials,
                    style: TextStyle(fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.customerName, style: AppTextStyles.titleMedium),
                  Text(
                    booking.customerNakshatra,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _row(Icons.phone_outlined, booking.customerPhone),
          _row(Icons.email_outlined, booking.customerEmail),
          _row(Icons.location_on_outlined, booking.customerLocation),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(text, style: AppTextStyles.bodySmall),
          ],
        ),
      );
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final rows = <(IconData, String, String)>[
      (Icons.local_fire_department_outlined, 'Service', booking.service),
      (Icons.timer_outlined, 'Duration', booking.duration),
      (Icons.calendar_today_outlined, 'Date', booking.date),
      (Icons.access_time_outlined, 'Time', booking.time),
      (Icons.location_on_outlined, 'Location', booking.location),
      (Icons.people_outline, 'Attendees', booking.attendees),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                AppStrings.bookingDetails,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(r.$1, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 10),
                  Text(r.$2, style: AppTextStyles.bodyMedium),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      r.$3,
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
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
