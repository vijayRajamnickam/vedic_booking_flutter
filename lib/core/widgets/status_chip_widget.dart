import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../ui/features/bookings/data/model/booking_model.dart';

class StatusChipWidget extends StatelessWidget {
  final BookingStatus status;
  final bool compact;

  const StatusChipWidget({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _config(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: config.$2.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.$2.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            config.$1,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: config.$2,
            ),
          ),
        ],
      ),
    );
  }

  static (String, Color) _config(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending:
        return ('⏳ Pending', AppColors.pending);
      case BookingStatus.confirmed:
        return ('✅ Confirmed', AppColors.confirmed);
      case BookingStatus.completed:
        return ('⭐ Completed', AppColors.completed);
      case BookingStatus.cancelled:
        return ('✖ Cancelled', AppColors.cancelled);
      case BookingStatus.inProgress:
        return ('🔄 In Progress', AppColors.primaryLight);
    }
  }
}
