import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../config/app_text_styles.dart';
import '../../ui/features/bookings/data/model/booking_model.dart';
import 'status_chip_widget.dart';

class BookingCardWidget extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  const BookingCardWidget({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            _Avatar(
              initials: booking.customerInitials,
              color: _parseColor(booking.customerAvatarColor),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          booking.customerName,
                          style: AppTextStyles.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₹${_formatAmount(booking.totalAmount)}',
                        style: AppTextStyles.amount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '#${booking.id}',
                    style: AppTextStyles.bookingId,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '${booking.serviceEmoji} ${booking.service}',
                          style: AppTextStyles.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusChipWidget(status: booking.status, compact: true),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📅 ${booking.date} • ${booking.time}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex));
    } catch (_) {
      return AppColors.primary;
    }
  }

  static String _formatAmount(int amount) {
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) {
      final s = amount.toString();
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return amount.toString();
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  final Color color;

  const _Avatar({required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
