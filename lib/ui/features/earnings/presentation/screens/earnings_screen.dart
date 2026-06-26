import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/shimmer_list_widget.dart';
import '../../data/model/earnings_model.dart';
import '../provider/earnings_provider.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(earningsProvider).fetchEarnings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(earningsProvider);
    final earnings = provider.earnings;

    if (provider.isLoading) {
      return const Scaffold(body: ShimmerListWidget());
    }

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.gold,
        onRefresh: () => ref.read(earningsProvider).fetchEarnings(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _EarningsHeader(earnings: earnings)),
            if (earnings != null) ...[
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: _ServicePerformance(
                      breakdown: earnings.serviceBreakdown),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('💸'),
                          const SizedBox(width: 6),
                          Text(AppStrings.recentTransactions,
                              style: AppTextStyles.headlineMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...earnings.transactions.map(
                        (t) => _TransactionCard(transaction: t),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Withdrawal coming soon!')),
              );
            },
            child: Text(
              AppStrings.withdrawEarnings,
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
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _EarningsHeader extends StatelessWidget {
  final EarningsModel? earnings;

  const _EarningsHeader({required this.earnings});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.totalEarnings} • ${earnings?.month ?? ''}',
                    style: AppTextStyles.bodyMediumOnPrimary.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          earnings?.month ?? 'May 2026',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down,
                            color: AppColors.white, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                earnings != null
                    ? '₹${_fmt(earnings!.totalThisMonth)}'
                    : '--',
                style: TextStyle(fontFamily: 'Poppins',
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              if (earnings != null)
                Text(
                  '▲ ${earnings!.growthPercent}% from last month',
                  style: AppTextStyles.bodyMediumOnPrimary.copyWith(
                    color: AppColors.confirmed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(height: 20),
              // Quick stats row
              Row(
                children: [
                  _QuickStat(
                      label: AppStrings.today,
                      value: earnings != null
                          ? '₹${_kFmt(earnings!.today)}'
                          : '--'),
                  const SizedBox(width: 10),
                  _QuickStat(
                      label: AppStrings.thisWeek,
                      value: earnings != null
                          ? '₹${_kFmt(earnings!.thisWeek)}'
                          : '--'),
                  const SizedBox(width: 10),
                  _QuickStat(
                      label: AppStrings.thisYear,
                      value: earnings != null
                          ? '₹${_lFmt(earnings!.thisYear)}'
                          : '--'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _fmt(int v) {
    final s = v.toString();
    if (s.length > 3) {
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return s;
  }

  static String _kFmt(int v) =>
      v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}K' : v.toString();

  static String _lFmt(int v) =>
      v >= 100000 ? '${(v / 100000).toStringAsFixed(1)}L' : _kFmt(v);
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;

  const _QuickStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Service performance ──────────────────────────────────────────────────────

class _ServicePerformance extends StatelessWidget {
  final List<ServiceBreakdown> breakdown;

  const _ServicePerformance({required this.breakdown});

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
              const Text('📊'),
              const SizedBox(width: 8),
              Text(AppStrings.servicePerformance,
                  style: AppTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          ...breakdown.map((b) => _BreakdownRow(item: b)),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final ServiceBreakdown item;

  const _BreakdownRow({required this.item});

  static const List<Color> _colors = [
    AppColors.cardPurple,
    AppColors.cardAmber,
    AppColors.cardRed,
    AppColors.cardGreen,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[_BreakdownRow._colorIndex(item.name)];

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item.emoji} ${item.name}',
                style: AppTextStyles.bodyLarge,
              ),
              Text(
                '₹${_fmt(item.amount)} • ${item.percent}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.percent / 100,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  static int _colorIndex(String name) {
    switch (name.toLowerCase()) {
      case 'homam':
        return 0;
      case 'pooja':
        return 1;
      case 'life events':
        return 2;
      default:
        return 3;
    }
  }

  static String _fmt(int v) {
    final s = v.toString();
    if (s.length > 3) {
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return s;
  }
}

// ─── Transaction card ─────────────────────────────────────────────────────────

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == 'credit';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isCredit
                  ? AppColors.confirmedSurface
                  : AppColors.cancelledSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(isCredit ? '💰' : '🏦', style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTextStyles.titleMedium),
                if (transaction.bookingRef != null)
                  Text(
                    '${transaction.bookingRef} • ${transaction.customer}',
                    style: AppTextStyles.bodySmall,
                  )
                else
                  Text(transaction.customer, style: AppTextStyles.bodySmall),
                Text(transaction.date, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'}₹${_fmt(transaction.amount)}',
                style: AppTextStyles.amount.copyWith(
                  color: isCredit ? AppColors.confirmed : AppColors.cancelled,
                ),
              ),
              Text(
                isCredit ? AppStrings.credited : AppStrings.debited,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
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
