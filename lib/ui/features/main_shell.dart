import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'home/presentation/screens/home_screen.dart';
import 'bookings/presentation/screens/bookings_screen.dart';
import 'earnings/presentation/screens/earnings_screen.dart';
import 'profile/presentation/screens/profile_screen.dart';

final _shellIndexProvider = StateProvider<int>((_) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    BookingsScreen(),
    EarningsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(_shellIndexProvider);

    return Scaffold(
      body: IndexedStack(index: index, children: _screens),
      bottomNavigationBar: _BottomNav(
        selectedIndex: index,
        onTap: (i) => ref.read(_shellIndexProvider.notifier).state = i,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  static const _items = [
    (label: AppStrings.navHome,     image: 'assets/images/nav_home.png'),
    (label: AppStrings.navBookings, image: 'assets/images/nav_bookings.png'),
    (label: AppStrings.navEarnings, image: 'assets/images/nav_earnings.png'),
    (label: AppStrings.navProfile,  image: 'assets/images/nav_profile.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.white;
    final selectedColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final unselectedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final isSelected = i == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: _NavItem(
                    imagePath: item.image,
                    label: item.label,
                    isSelected: isSelected,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;

  const _NavItem({
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Transparent-background PNG icon
        Opacity(
          opacity: isSelected ? 1.0 : 0.5,
          child: Image.asset(
            imagePath,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 3),
        // Label
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? selectedColor : unselectedColor,
          ),
        ),
        const SizedBox(height: 3),
        // Dot indicator
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? 5 : 0,
          height: isSelected ? 5 : 0,
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
