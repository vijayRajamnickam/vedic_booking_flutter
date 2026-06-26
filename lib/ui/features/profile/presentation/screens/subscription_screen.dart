import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          _SubscriptionHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: Column(
                children: [
                  // Active plan banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.confirmedSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.confirmed.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.confirmed, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active: Sacred Pro',
                                style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.confirmed),
                              ),
                              Text(
                                'Renews on 01 Jun 2026',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.confirmed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'PRO',
                            style: TextStyle(fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Plan cards
                  _PlanCard(
                    emoji: '🌸',
                    name: AppStrings.sacredBasic,
                    subtitle: 'Getting started',
                    price: 'Free',
                    priceSuffix: '/ lifetime',
                    features: const [
                      'Up to 10 bookings/month',
                      '15% platform commission',
                      'Basic profile listing',
                    ],
                    ctaLabel: AppStrings.selectBasic,
                    ctaStyle: _CtaStyle.outlined,
                    isActive: false,
                    badgeLabel: null,
                    badgeColor: null,
                  ),
                  const SizedBox(height: 16),
                  _PlanCard(
                    emoji: '⭐',
                    name: AppStrings.sacredPro,
                    subtitle: 'High performance',
                    price: '₹999',
                    priceSuffix: '/ month',
                    features: const [
                      'Unlimited bookings',
                      'Only 10% commission',
                      'Featured profile & Priority search',
                      '24/7 priority support access',
                    ],
                    ctaLabel: AppStrings.currentActivePlan,
                    ctaStyle: _CtaStyle.active,
                    isActive: true,
                    badgeLabel: '★ POPULAR',
                    badgeColor: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  _PlanCard(
                    emoji: '👑',
                    name: AppStrings.sacredElite,
                    subtitle: 'Master Pandit status',
                    price: '₹2,499',
                    priceSuffix: '/ month',
                    features: const [
                      'Everything in Sacred Pro',
                      'Only 5% commission • Top results',
                      'Dedicated account manager',
                      'Verified Elite badge & Campaigns',
                    ],
                    ctaLabel: AppStrings.upgradeToElite,
                    ctaStyle: _CtaStyle.gradient,
                    isActive: false,
                    badgeLabel: '🔥 PREMIUM',
                    badgeColor: AppColors.buttonGradientEnd,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.planDisclaimer,
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
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

class _SubscriptionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 28),
          child: Row(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              const Text('⭐', style: TextStyle(fontSize: 32)),
              const Spacer(),
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }
}

enum _CtaStyle { outlined, active, gradient }

class _PlanCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String subtitle;
  final String price;
  final String priceSuffix;
  final List<String> features;
  final String ctaLabel;
  final _CtaStyle ctaStyle;
  final bool isActive;
  final String? badgeLabel;
  final Color? badgeColor;

  const _PlanCard({
    required this.emoji,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.priceSuffix,
    required this.features,
    required this.ctaLabel,
    required this.ctaStyle,
    required this.isActive,
    required this.badgeLabel,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: isActive
                ? Border.all(color: AppColors.primary, width: 2)
                : Border.all(color: AppColors.divider),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyles.headlineMedium),
                      Text(subtitle, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: TextStyle(fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      priceSuffix,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        isActive
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        size: 16,
                        color: isActive ? AppColors.primary : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(f, style: AppTextStyles.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildCta(context),
            ],
          ),
        ),
        if (badgeLabel != null)
          Positioned(
            top: -10,
            right: 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badgeLabel!,
                style: TextStyle(fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCta(BuildContext context) {
    switch (ctaStyle) {
      case _CtaStyle.outlined:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: Text(
              ctaLabel,
              style: TextStyle(fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      case _CtaStyle.active:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.check_circle_outline,
                color: AppColors.white, size: 16),
            label: Text(
              ctaLabel,
              style: TextStyle(fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            onPressed: null,
          ),
        );
      case _CtaStyle.gradient:
        return GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.buttonGradientStart, AppColors.buttonGradientEnd],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                ctaLabel,
                style: TextStyle(fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        );
    }
  }
}
