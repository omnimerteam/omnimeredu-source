import 'package:flutter/material.dart';
import '../../../../widgets/skeleton/common_skeleton.dart';

class DashboardQuickOverviewSkeleton extends StatelessWidget {
  const DashboardQuickOverviewSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(height: 24, width: 200), // title
            const SizedBox(height: 16),

            Row(
              children: const [
                Expanded(child: _StatCardSkeleton()),
                SizedBox(width: 12),
                Expanded(child: _StatCardSkeleton()),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: const [
                Expanded(child: _StatCardSkeleton()),
                SizedBox(width: 12),
                Expanded(child: _StatCardSkeleton()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCardSkeleton extends StatelessWidget {
  const _StatCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SkeletonBox(height: 40, width: 40, borderRadius: 12),
        SizedBox(height: 12),
        SkeletonBox(height: 20, width: 80),
        SizedBox(height: 8),
        SkeletonBox(height: 14, width: 60),
      ],
    );
  }
}
