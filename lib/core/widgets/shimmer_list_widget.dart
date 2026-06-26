import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListWidget extends StatelessWidget {
  final int itemCount;

  const ShimmerListWidget({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A0050) : const Color(0xFFE8E8F0),
      highlightColor: isDark ? const Color(0xFF3D1066) : const Color(0xFFF5F5FF),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: itemCount,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, i) => const _ShimmerCard(),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardTheme.color ?? Colors.white;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 140, color: cardColor),
                const SizedBox(height: 6),
                Container(height: 10, width: 80, color: cardColor),
                const SizedBox(height: 8),
                Container(height: 10, width: double.infinity, color: cardColor),
                const SizedBox(height: 4),
                Container(height: 10, width: 160, color: cardColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
