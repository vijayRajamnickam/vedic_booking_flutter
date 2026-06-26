import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/app_routes.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../data/model/booking_model.dart';
import '../provider/bookings_provider.dart';

class BookingDetailsScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(bookingsProvider);
    final booking = provider.getBookingById(bookingId);

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Details')),
        body: const Center(child: Text('Booking not found')),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _DetailHeader(booking: booking),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                children: [
                  // Pending state banner + action buttons
                  if (booking.status == BookingStatus.pending) ...[
                    _PendingBanner(),
                    const SizedBox(height: 12),
                    _AcceptDeclineRow(bookingId: bookingId),
                    const SizedBox(height: 20),
                  ],
                  // Customer details
                  _SectionCard(
                    title: AppStrings.customerDetails,
                    icon: Icons.person_outline,
                    child: _CustomerDetails(booking: booking),
                  ),
                  const SizedBox(height: 16),
                  // Booking details
                  _SectionCard(
                    title: AppStrings.bookingDetails,
                    icon: Icons.calendar_today_outlined,
                    child: _BookingInfo(booking: booking),
                  ),
                  // Payment details — only for pending bookings (as per design)
                  if (booking.status == BookingStatus.pending) ...[
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: AppStrings.paymentDetails,
                      icon: Icons.credit_card_outlined,
                      child: _PaymentDetails(booking: booking),
                    ),
                    const SizedBox(height: 16),
                    // Map placeholder
                    _MapPlaceholder(),
                    const SizedBox(height: 16),
                    // Special instructions
                    _SectionCard(
                      title: AppStrings.specialInstructions,
                      icon: Icons.note_outlined,
                      child: Text(
                        booking.specialInstructions,
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Bottom CTA
          _BottomCta(booking: booking, bookingId: bookingId),
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  final BookingModel booking;

  const _DetailHeader({required this.booking});

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
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${booking.id} • ${booking.date}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.service,
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pending banner ──────────────────────────────────────────────────────────

class _PendingBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.pending.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.pending.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⏳', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            AppStrings.awaitingConfirmation,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.pending,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Accept / Decline row ────────────────────────────────────────────────────

class _AcceptDeclineRow extends ConsumerWidget {
  final String bookingId;

  const _AcceptDeclineRow({required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.confirmed,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.check_circle_outline, color: AppColors.white),
            label: Text(
              AppStrings.accept,
              style: TextStyle(fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            onPressed: () async {
              final ok =
                  await ref.read(bookingsProvider).acceptBooking(bookingId);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking accepted!'),
                    backgroundColor: AppColors.confirmed,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.cancelled,
              side: const BorderSide(color: AppColors.cancelled),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.cancel_outlined),
            label: Text(
              AppStrings.decline,
              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600),
            ),
            onPressed: () async {
              final ok =
                  await ref.read(bookingsProvider).declineBooking(bookingId);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking declined.'),
                    backgroundColor: AppColors.cancelled,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ],
    );
  }
}

// ─── Section card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
          child,
        ],
      ),
    );
  }
}

// ─── Customer details ─────────────────────────────────────────────────────────

class _CustomerDetails extends StatelessWidget {
  final BookingModel booking;

  const _CustomerDetails({required this.booking});

  @override
  Widget build(BuildContext context) {
    Color avatarColor;
    try {
      avatarColor = Color(int.parse(booking.customerAvatarColor));
    } catch (_) {
      avatarColor = AppColors.primary;
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: avatarColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  booking.customerInitials,
                  style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.customerName, style: AppTextStyles.titleLarge),
                Text(
                  booking.customerNakshatra,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < booking.customerRating.floor()
                          ? Icons.star
                          : (booking.customerRating - i >= 0.5
                              ? Icons.star_half
                              : Icons.star_border),
                      size: 14,
                      color: AppColors.gold,
                    );
                  })
                    ..add(const SizedBox(width: 4))
                    ..add(Text(
                      '${booking.customerRating} (${booking.customerBookingCount} bookings)',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.gold),
                    )),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        _ContactRow(icon: Icons.phone_outlined, text: booking.customerPhone),
        _ContactRow(icon: Icons.email_outlined, text: booking.customerEmail),
        _ContactRow(icon: Icons.location_on_outlined, text: booking.customerLocation),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Text(text, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

// ─── Booking info ──────────────────────────────────────────────────────────────

class _BookingInfo extends StatelessWidget {
  final BookingModel booking;

  const _BookingInfo({required this.booking});

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

    return Column(
      children: rows
          .map(
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
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// ─── Payment details ──────────────────────────────────────────────────────────

class _PaymentDetails extends StatelessWidget {
  final BookingModel booking;

  const _PaymentDetails({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PayRow(label: AppStrings.serviceFee, amount: booking.serviceFee),
        _PayRow(label: AppStrings.platformFee, amount: booking.platformFee),
        _PayRow(label: AppStrings.gst, amount: booking.gst),
        const Divider(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.totalAmount,
              style: AppTextStyles.titleMedium,
            ),
            Text(
              '₹${_fmt(booking.totalAmount)}',
              style: AppTextStyles.amount.copyWith(
                fontSize: 20,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _fmt(int v) {
    final s = v.toString();
    if (s.length > 3) {
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return s;
  }
}

class _PayRow extends StatelessWidget {
  final String label;
  final int amount;

  const _PayRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            '₹${_PaymentDetails._fmt(amount)}',
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}

// ─── Map placeholder ──────────────────────────────────────────────────────────

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppColors.darkDivider : AppColors.divider),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.map_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_pin,
                        color: AppColors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.location,
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.clickToSeeLocation,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom CTA ───────────────────────────────────────────────────────────────

class _BottomCta extends ConsumerWidget {
  final BookingModel booking;
  final String bookingId;

  const _BottomCta({required this.booking, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // pending → no bottom CTA (handled by Accept/Decline row)
    if (booking.status == BookingStatus.pending) return const SizedBox.shrink();
    // cancelled or completed → no CTA
    if (booking.status == BookingStatus.cancelled ||
        booking.status == BookingStatus.completed) {
      return const SizedBox.shrink();
    }

    final isInProgress = booking.status == BookingStatus.inProgress;
    final label = isInProgress ? AppStrings.endRitual : AppStrings.startRitual;

    return SafeArea(
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
            onPressed: () => _onCtaTap(context, ref, isInProgress),
            child: Text(
              label,
              style: TextStyle(fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onCtaTap(BuildContext context, WidgetRef ref, bool isInProgress) {
    if (isInProgress) {
      // End ritual confirmation dialog
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary),
              onPressed: () async {
                Navigator.of(ctx).pop();
                final ok = await ref.read(bookingsProvider).endRitual(bookingId);
                if (ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.ritualCompleted),
                      backgroundColor: AppColors.completed,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text(AppStrings.confirm),
            ),
          ],
        ),
      );
    } else {
      // Go to OTP verification
      Navigator.of(context).pushNamed(
        AppRoutes.ritualVerification,
        arguments: {'bookingId': bookingId},
      );
    }
  }
}
