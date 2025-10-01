import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/skeleton/common_skeleton.dart';

class TeacherClassesLoading extends StatelessWidget {
  const TeacherClassesLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const SkeletonBox(height: 48, width: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(height: 16, width: 150),
                    SizedBox(height: 8),
                    SkeletonBox(height: 14, width: 200),
                    SizedBox(height: 4),
                    SkeletonBox(height: 14, width: 100),
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
