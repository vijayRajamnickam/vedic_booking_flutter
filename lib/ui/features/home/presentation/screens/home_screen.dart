import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/app_routes.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/booking_card_widget.dart';
import '../../../../../core/widgets/shimmer_list_widget.dart';
import '../../../../features/bookings/data/model/booking_model.dart';
import '../../../../features/bookings/presentation/provider/bookings_provider.dart';
import '../provider/home_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider).fetchDashboard();
      ref.read(bookingsProvider).fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hp = ref.watch(homeProvider);
    final bp = ref.watch(bookingsProvider);

    final pendingBookings = bp.bookings
        .where((b) => b.status == BookingStatus.pending)
        .take(3)
        .toList();

    return Scaffold(
      body: Column(
        children: [
          // ── Fixed header — never scrolls ──────────────────────────────
          _HomeHeader(provider: hp),

          // ── Scrollable white content below ───────────────────────────
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                await ref.read(homeProvider).fetchDashboard();
                await ref.read(bookingsProvider).fetchBookings();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's overview
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.todaysOverview,
                            style: AppTextStyles.headlineMedium),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            AppStrings.viewAll,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 12),
                    _StatsGrid(provider: hp),
                    const SizedBox(height: 24),

                    // New booking requests header
                    Row(
                      children: [
                        Text(AppStrings.newBookingRequests,
                            style: AppTextStyles.headlineMedium),
                        const SizedBox(width: 8),
                        if (bp.pendingCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${bp.pendingCount} New',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Pending booking cards
                    if (bp.isLoading)
                      ShimmerListWidget(itemCount: 3)
                    else
                      ...pendingBookings.map(
                        (b) => BookingCardWidget(
                          booking: b,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.bookingDetails,
                            arguments: {'bookingId': b.id},
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Today's Muhurtha card
                    if (hp.dashboard != null)
                      _MuhurthaCard(muhurtha: hp.dashboard!.todaysMuhurtha),
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

// ─── Header ──────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  final HomeProvider provider;

  const _HomeHeader({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🙏 ${AppStrings.namaste}',
                        style: AppTextStyles.bodyMediumOnPrimary,
                      ),
                      Text(
                        'Pandit Iyer',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: AppColors.white),
                    onPressed: () {},
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'PI',
                        style: TextStyle(fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Availability toggle
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.availabilityStatus,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: provider.isAvailable
                                      ? AppColors.confirmed
                                      : AppColors.textHint,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppStrings.availableForBookings,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: provider.isAvailable,
                      onChanged: (_) =>
                          provider.toggleAvailability(),
                      activeThumbColor: AppColors.confirmed,
                      activeTrackColor:
                          AppColors.confirmed.withValues(alpha: 0.4),
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

// ─── Stats grid ───────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final HomeProvider provider;

  const _StatsGrid({required this.provider});

  @override
  Widget build(BuildContext context) {
    final dashboard = provider.dashboard;
    final cards = <(String, String, String, Color)>[
      (
        AppStrings.totalBookings,
        dashboard != null ? '${dashboard.totalBookings}' : '--',
        '▲ ${dashboard?.totalBookingsGrowth ?? 0}% this month',
        AppColors.cardPurple,
      ),
      (
        AppStrings.pending,
        dashboard != null ? '${dashboard.pendingBookings}' : '--',
        AppStrings.actionRequired,
        AppColors.cardAmber,
      ),
      (
        'COMPLETED',
        dashboard != null ? '${dashboard.completedBookings}' : '--',
        '▲ ${dashboard?.completedGrowth ?? 0}% growth',
        AppColors.cardGreen,
      ),
      (
        AppStrings.earnings,
        dashboard != null
            ? '${(dashboard.earningsThisMonth / 1000).toStringAsFixed(0)}K'
            : '--',
        AppStrings.thisMonth,
        AppColors.cardRed,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: cards
          .map(
            (c) => _StatCard(
              label: c.$1,
              value: c.$2,
              subtitle: c.$3,
              color: c.$4,
            ),
          )
          .toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.statLabel,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(value, style: AppTextStyles.statNumber),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.statLabel.copyWith(fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Muhurtha card ────────────────────────────────────────────────────────────

class _MuhurthaCard extends StatelessWidget {
  final dynamic muhurtha;

  const _MuhurthaCard({required this.muhurtha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primaryMedium],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.todaysMuhurtha,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.gold,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            muhurtha.name as String,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.white,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            muhurtha.timeRange as String,
            style: TextStyle(fontFamily: 'Poppins',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            muhurtha.description as String,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
