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
  bool _showSearch = false;

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

  void _toggleSearch() {
    setState(() => _showSearch = !_showSearch);
    if (!_showSearch) {
      _searchController.clear();
      ref.read(bookingsProvider).setSearch('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(bookingsProvider);

    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _Header(
                searchController: _searchController,
                showSearch: _showSearch,
                onSearchToggle: _toggleSearch,
                onSearchChanged: (q) => ref.read(bookingsProvider).setSearch(q),
              ),
              Positioned(
                bottom: -40,
                left: 16,
                right: 16,
                height: 80,
                child: _StatsCard(provider: provider),
              ),
            ],
          ),
          const SizedBox(height: 52),
          Expanded(child: _Body(provider: provider)),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final TextEditingController searchController;
  final bool showSearch;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;

  const _Header({
    required this.searchController,
    required this.showSearch,
    required this.onSearchToggle,
    required this.onSearchChanged,
  });

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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar — toggles between label+icons and search field
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: showSearch
                    ? _SearchRow(
                        key: const ValueKey('search'),
                        controller: searchController,
                        onChanged: onSearchChanged,
                        onClose: onSearchToggle,
                      )
                    : _LabelRow(
                        key: const ValueKey('label'),
                        onSearchTap: onSearchToggle,
                      ),
              ),
              const SizedBox(height: 14),
              Text(
                AppStrings.myBookings,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  final VoidCallback onSearchTap;

  const _LabelRow({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.bookingRegistry,
          style: AppTextStyles.bodyMediumOnPrimary.copyWith(fontSize: 13),
        ),
        const Spacer(),
        _IconBtn(icon: Icons.search, onTap: onSearchTap),
        const SizedBox(width: 10),
        _IconBtn(
          icon: Icons.notifications_outlined,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  '🔔 Notifications coming soon!',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          hasBadge: true,
        ),
      ],
    );
  }
}

class _SearchRow extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  const _SearchRow({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            autofocus: true,
            onChanged: onChanged,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.white.withValues(alpha: 0.55),
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.white,
                size: 20,
              ),
              filled: true,
              fillColor: AppColors.white.withValues(alpha: 0.15),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.white.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.white.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _IconBtn(icon: Icons.close, onTap: onClose),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
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
              right: 7,
              top: 7,
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
      ),
    );
  }
}

// ─── Stats card ───────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  final BookingsProvider provider;

  const _StatsCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatCell(
            value: '${provider.totalCount}',
            label: AppStrings.total,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          _Divider(),
          _StatCell(
            value: '${provider.pendingCount}',
            label: 'Pending',
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
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
    return Container(width: 1, height: 36, color: AppColors.divider);
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
            onSelected: (_) => ref.read(bookingsProvider).setFilter(status),
            selectedColor: AppColors.primary,
            backgroundColor: Theme.of(context).cardTheme.color,
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? AppColors.white : AppColors.textSecondary,
            ),
            side: BorderSide(
              color: isActive ? AppColors.primary : AppColors.divider,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
