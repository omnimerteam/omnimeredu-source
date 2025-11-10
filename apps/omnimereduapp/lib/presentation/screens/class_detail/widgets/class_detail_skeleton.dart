import 'package:flutter/material.dart';
import '../../../widgets/skeleton/common_skeleton.dart';

class ClassDetailSkeleton extends StatelessWidget {
  const ClassDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class Info Card Skeleton
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonBox(width: 100, height: 20),
                  const SizedBox(height: 8),
                  const SkeletonBox(width: 200, height: 18),
                  const SizedBox(height: 4),
                  const SkeletonBox(width: 80, height: 16),
                  const SizedBox(height: 16),
                  const SkeletonBox(width: 100, height: 20),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SkeletonBox(width: 120, height: 18),
                      const SizedBox(width: 8),
                      const SkeletonBox(width: 60, height: 16),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SkeletonBox(width: 120, height: 20),
                  const SizedBox(height: 8),
                  const SkeletonBox(width: 150, height: 18),
                  const SizedBox(height: 16),
                  const SkeletonBox(width: 100, height: 20),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      const SkeletonBox(
                        width: 150,
                        height: 32,
                        borderRadius: 20,
                      ),
                      const SkeletonBox(
                        width: 120,
                        height: 32,
                        borderRadius: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Search Field Skeleton
          const SkeletonBox(
            width: double.infinity,
            height: 56,
            borderRadius: 16,
          ),
          const SizedBox(height: 16),

          // Student List Title Skeleton
          const SkeletonBox(width: 150, height: 24),
          const SizedBox(height: 16),

          // Student Cards Skeleton
          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SkeletonBox(
                            width: 48,
                            height: 48,
                            borderRadius: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SkeletonBox(width: 150, height: 18),
                                const SizedBox(height: 4),
                                const SkeletonBox(width: 60, height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      const SkeletonBox(width: 200, height: 16),
                      const SizedBox(height: 8),
                      const SkeletonBox(width: double.infinity, height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
