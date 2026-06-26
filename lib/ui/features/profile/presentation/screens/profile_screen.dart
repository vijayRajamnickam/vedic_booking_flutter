import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/app_routes.dart';
import '../../../../../core/config/app_text_styles.dart';
import '../../../../../core/config/theme_provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(profileProvider);
    final profile = provider.profile;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _ProfileHeader(profile: profile)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ACCOUNT section
                  Text(AppStrings.account,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                      )),
                  const SizedBox(height: 8),
                  _MenuCard(items: [
                    _MenuItem(
                      icon: Icons.person_outline,
                      iconColor: AppColors.primary,
                      title: AppStrings.editProfile,
                      subtitle: AppStrings.editProfileSub,
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.self_improvement,
                      iconColor: AppColors.primaryLight,
                      title: AppStrings.expertiseServices,
                      subtitle: AppStrings.expertiseServicesSub,
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.phone_outlined,
                      iconColor: AppColors.confirmed,
                      title: AppStrings.contactDetails,
                      subtitle: AppStrings.contactDetailsSub,
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      iconColor: AppColors.cancelled,
                      title: AppStrings.serviceLocation,
                      subtitle: AppStrings.serviceLocationSub,
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 20),
                  // SERVICES section
                  Text(AppStrings.services,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                      )),
                  const SizedBox(height: 8),
                  _MenuCard(items: [
                    _MenuItem(
                      icon: Icons.calendar_today_outlined,
                      iconColor: AppColors.primary,
                      title: AppStrings.viewBookings,
                      subtitle: AppStrings.viewBookingsSub,
                      badge: '8',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.star_outline,
                      iconColor: AppColors.gold,
                      title: AppStrings.subscription,
                      subtitle: 'Sacred Pro – Active',
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.subscription),
                    ),
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      iconColor: AppColors.pending,
                      title: AppStrings.notifications,
                      subtitle: AppStrings.notificationsSub,
                      badge: '3',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 20),
                  // Theme toggle (not in design — added as required)
                  _ThemeToggleCard(),
                  const SizedBox(height: 24),
                  // Sign out
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.cancelled,
                        side: const BorderSide(color: AppColors.cancelled),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        AppStrings.signOut,
                        style: TextStyle(fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final dynamic profile;

  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        profile?.avatarInitials as String? ?? 'PI',
                        style: TextStyle(fontFamily: 'Poppins',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit,
                          size: 14, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                profile?.name as String? ?? 'Pandit Iyer',
                style: AppTextStyles.headlineLarge
                    .copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${profile?.id ?? 'VEDIC-2024-0142'} • ${profile?.location ?? 'Chennai'}',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.white.withValues(alpha: 0.8)),
              ),
              const SizedBox(height: 8),
              // Stars + rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    5,
                    (i) => Icon(Icons.star, size: 16, color: AppColors.gold),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${profile?.rating ?? 4.9} (${profile?.reviewCount ?? 238} reviews)',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Featured badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppStrings.featuredPandit,
                  style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Stats row
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _ProfileStat(
                      value: '${profile?.totalBookings ?? 142}',
                      label: AppStrings.bookingsLabel,
                    ),
                    _Divider(),
                    _ProfileStat(
                      value: '${profile?.yearsExperience ?? 12}',
                      label: AppStrings.yrsExpLabel,
                    ),
                    _Divider(),
                    _ProfileStat(
                      value: profile != null
                          ? '₹${(profile!.totalEarned / 100000).toStringAsFixed(1)}L'
                          : '₹2.4L',
                      label: AppStrings.earnedLabel,
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

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          Text(label, style: AppTextStyles.bodySmall),
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

// ─── Menu card ────────────────────────────────────────────────────────────────

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;

  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              _MenuTile(item: item),
              if (i < items.length - 1)
                const Divider(height: 1, indent: 56),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.onTap,
  });
}

class _MenuTile extends StatelessWidget {
  final _MenuItem item;

  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 18, color: item.iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.titleMedium),
                  Text(item.subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            if (item.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.badge!,
                  style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              )
            else
              const Icon(Icons.chevron_right,
                  size: 20, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

// ─── Theme toggle ─────────────────────────────────────────────────────────────

class _ThemeToggleCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              themeNotifier.isDark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.themeLabel, style: AppTextStyles.titleMedium),
                Text(AppStrings.themeSub, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Switch(
            value: themeNotifier.isDark,
            onChanged: (_) => ref.read(themeProvider).toggle(),
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primarySurface,
          ),
        ],
      ),
    );
  }
}
