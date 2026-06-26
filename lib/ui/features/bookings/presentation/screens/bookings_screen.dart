import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/app_routes.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/booking_card_widget.dart';
import '../../../../../core/widgets/empty_state_widget.dart';
import '../../../../../core/widgets/shimmer_list_widget.dart';
import '../../data/model/booking_model.dart';
import '../provider/bookings_provider.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingsProvider).fetchBookings();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(bookingsProvider);

    return Scaffold(
      body: Column(
        children: [
          _Header(provider: provider, searchController: _searchController),
          Expanded(
            child: _Body(provider: provider),
          ),
        ],
      ),
    );
  }
}

// ─── Header (purple) ─────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final BookingsProvider provider;
  final TextEditingController searchController;

  const _Header({required this.provider, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Text(
                    AppStrings.bookingRegistry,
                    style: AppTextStyles.bodyMediumOnPrimary.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  _IconBtn(
                    icon: Icons.search,
                    onTap: () {}, // search handled inline
                  ),
                  const SizedBox(width: 8),
                  _IconBtn(icon: Icons.notifications_outlined, onTap: () {}),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                AppStrings.myBookings,
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Stats row
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _StatCell(
                    value: '${provider.totalCount}',
                    label: AppStrings.total,
                    color: AppColors.textPrimary,
                  ),
                  _Divider(),
                  _StatCell(
                    value: '${provider.pendingCount}',
                    label: AppStrings.pending.replaceAll('PENDING', 'Pending'),
                    color: AppColors.pending,
                  ),
                  _Divider(),
                  _StatCell(
                    value: '${provider.completedCount}',
                    label: 'Completed',
                    color: AppColors.confirmed,
                  ),
                  _Divider(),
                  _StatCell(
                    value: '${provider.cancelledCount}',
                    label: AppStrings.cancelled,
                    color: AppColors.cancelled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCell({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.divider,
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends ConsumerWidget {
  final BookingsProvider provider;

  const _Body({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (provider.isLoading) {
      return const ShimmerListWidget();
    }

    if (provider.errorMessage != null) {
      return EmptyStateWidget(
        icon: Icons.error_outline,
        title: 'Error loading bookings',
        subtitle: provider.errorMessage!,
        onRetry: () => ref.read(bookingsProvider).fetchBookings(),
      );
    }

    return Column(
      children: [
        // Search bar
        _SearchBar(
          onChanged: (q) => ref.read(bookingsProvider).setSearch(q),
        ),
        // Filter chips
        _FilterChips(provider: provider),
        // List
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => ref.read(bookingsProvider).fetchBookings(),
            child: provider.bookings.isEmpty
                ? ListView(
                    children: [
                      EmptyStateWidget(
                        title: AppStrings.emptyBookings,
                        subtitle: AppStrings.emptyBookingsSubtitle,
                        icon: Icons.calendar_today_outlined,
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: provider.bookings.length,
                    itemBuilder: (_, i) {
                      final booking = provider.bookings[i];
                      return BookingCardWidget(
                        booking: booking,
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.bookingDetails,
                          arguments: {'bookingId': booking.id},
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

class _FilterChips extends ConsumerWidget {
  final BookingsProvider provider;

  const _FilterChips({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = <(String, BookingStatus?)>[
      (AppStrings.filterAll, null),
      ('🔥 Pending', BookingStatus.pending),
      ('✅ Confirmed', BookingStatus.confirmed),
      ('⭐ Completed', BookingStatus.completed),
      ('✖ Cancelled', BookingStatus.cancelled),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (ctx, i) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (label, status) = filters[i];
          final isActive = provider.activeFilter == status;
          return ChoiceChip(
            label: Text(label),
            selected: isActive,
            onSelected: (_) =>
                ref.read(bookingsProvider).setFilter(status),
            selectedColor: AppColors.primary,
            backgroundColor: Theme.of(context).cardTheme.color,
            labelStyle: TextStyle(fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? AppColors.white : AppColors.textSecondary,
            ),
            side: BorderSide(
              color: isActive ? AppColors.primary : AppColors.divider,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
