import 'package:flutter/material.dart';
import '../../../widgets/skeleton/common_skeleton.dart';

class AttendanceDetailLoadingView extends StatelessWidget {
  const AttendanceDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(
        8,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SkeletonBox(height: 56, width: 56, borderRadius: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(height: 20, width: double.infinity),
                    SizedBox(height: 8),
                    SkeletonBox(height: 16, width: 200),
                    SizedBox(height: 6),
                    SkeletonBox(height: 16, width: 150),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const SkeletonBox(height: 32, width: 80, borderRadius: 16),
            ],
          ),
        ),
      ),
    );
  }
}
