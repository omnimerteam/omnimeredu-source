import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Step titles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              return Expanded(
                child: Text(
                  stepTitles[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: index <= currentStep
                        ? AppColors.primary
                        : Colors.grey[600],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),

          // Progress bars
          Row(
            children: List.generate(totalSteps, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < totalSteps - 1 ? 8 : 0,
                  ),
                  height: 4,
                  decoration: BoxDecoration(
                    color: index <= currentStep
                        ? AppColors.primary
                        : AppColors.extraLightBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
