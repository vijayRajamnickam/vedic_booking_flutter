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
      body: Column(
        children: [
          // ── Fixed header + straddling stats card ──────────────────────────
          Stack(
            clipBehavior: Clip.none,
            children: [
              _EarningsHeader(earnings: earnings),
              Positioned(
                bottom: -40,
                left: 16,
                right: 16,
                height: 80,
                child: _QuickStatsCard(earnings: earnings),
              ),
            ],
          ),
          const SizedBox(height: 52), // 40 lower-half + 12 gap

          // ── Scrollable body ───────────────────────────────────────────────
          Expanded(
            child: RefreshIndicator(
              color: AppColors.gold,
              onRefresh: () => ref.read(earningsProvider).fetchEarnings(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: earnings == null
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          _ServicePerformance(
                              breakdown: earnings.serviceBreakdown),
                          const SizedBox(height: 20),
                          _RecentTransactions(
                              transactions: earnings.transactions),
                          const SizedBox(height: 20),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _WithdrawButton(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '💸 Withdrawal coming soon!',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        ),
      ),
    );
  }
}

// ─── Header (purple, rounded bottom) ─────────────────────────────────────────

class _EarningsHeader extends StatelessWidget {
  final EarningsModel? earnings;

  const _EarningsHeader({required this.earnings});

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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row + month pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.totalEarnings} • ${earnings?.month ?? 'Jun 2026'}',
                    style: AppTextStyles.bodyMediumOnPrimary
                        .copyWith(fontSize: 13),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          earnings?.month ?? 'Jun 2026',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
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
              const SizedBox(height: 10),
              // Big amount
              Text(
                earnings != null ? '₹${_fmt(earnings!.totalThisMonth)}' : '--',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              if (earnings != null)
                Row(
                  children: [
                    const Icon(Icons.arrow_upward,
                        color: AppColors.confirmed, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${earnings!.growthPercent}% from last month',
                      style: AppTextStyles.bodyMediumOnPrimary.copyWith(
                        color: AppColors.confirmed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 25),
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
}

// ─── Quick stats card (straddles header boundary) ────────────────────────────

class _QuickStatsCard extends StatelessWidget {
  final EarningsModel? earnings;

  const _QuickStatsCard({required this.earnings});

  static String _kFmt(int v) =>
      v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}K' : v.toString();

  static String _lFmt(int v) =>
      v >= 100000 ? '${(v / 100000).toStringAsFixed(1)}L' : _kFmt(v);

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
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatCell(
            label: AppStrings.today,
            value: earnings != null ? '₹${_kFmt(earnings!.today)}' : '--',
            color: AppColors.primary,
          ),
          _VerticalDivider(),
          _StatCell(
            label: AppStrings.thisWeek,
            value: earnings != null ? '₹${_kFmt(earnings!.thisWeek)}' : '--',
            color: AppColors.pending,
          ),
          _VerticalDivider(),
          _StatCell(
            label: AppStrings.thisYear,
            value: earnings != null ? '₹${_lFmt(earnings!.thisYear)}' : '--',
            color: AppColors.confirmed,
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCell({
    required this.label,
    required this.value,
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
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
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

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.divider);
  }
}

// ─── Service Performance ──────────────────────────────────────────────────────

class _ServicePerformance extends StatelessWidget {
  final List<ServiceBreakdown> breakdown;

  const _ServicePerformance({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(AppStrings.servicePerformance,
                  style: AppTextStyles.headlineMedium),
            ],
          ),
          const SizedBox(height: 18),
          ...breakdown.map((b) => _BreakdownRow(item: b)),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final ServiceBreakdown item;

  const _BreakdownRow({required this.item});

  static const List<Color> _barColors = [
    AppColors.cardPurple,
    AppColors.cardAmber,
    Color(0xFF0EA5E9),
    AppColors.cardGreen,
  ];

  static int _colorIndex(String name) {
    switch (name.toLowerCase()) {
      case 'homam':       return 0;
      case 'pooja':       return 1;
      case 'life events': return 2;
      default:            return 3;
    }
  }

  static String _fmt(int v) {
    final s = v.toString();
    if (s.length > 3) {
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final color = _barColors[_colorIndex(item.name)];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${item.emoji}  ${item.name}',
                  style: AppTextStyles.bodyLarge),
              Text(
                '₹${_fmt(item.amount)} • ${item.percent}%',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: item.percent / 100,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recent Transactions ──────────────────────────────────────────────────────

class _RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const _RecentTransactions({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('💰', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(AppStrings.recentTransactions,
                style: AppTextStyles.headlineMedium),
          ],
        ),
        const SizedBox(height: 14),
        ...transactions.map((t) => _TransactionCard(transaction: t)),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == 'credit';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isCredit
                  ? AppColors.confirmedSurface
                  : AppColors.cancelledSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(isCredit ? '💰' : '🏦',
                  style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                if (transaction.bookingRef != null)
                  Text('${transaction.bookingRef} • ${transaction.customer}',
                      style: AppTextStyles.bodySmall)
                else
                  Text(transaction.customer, style: AppTextStyles.bodySmall),
                const SizedBox(height: 1),
                Text(transaction.date, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'}₹${_fmt(transaction.amount)}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isCredit ? AppColors.confirmed : AppColors.cancelled,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isCredit ? AppStrings.credited : AppStrings.debited,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: isCredit ? AppColors.confirmed : AppColors.cancelled,
                ),
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

// ─── Withdraw Button ──────────────────────────────────────────────────────────

class _WithdrawButton extends StatelessWidget {
  final VoidCallback onTap;

  const _WithdrawButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  57,
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryMedium, AppColors.primaryDark],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '🏛  Withdraw Earnings',
              style: TextStyle(
                fontFamily: 'Poppins',
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
