import 'package:flutter/material.dart';

class TeacherClassesHeader extends StatelessWidget {
  final int total;
  final bool isLoading;

  const TeacherClassesHeader({
    Key? key,
    required this.total,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lớp học quản lý',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (!isLoading)
          Text(
            '$total lớp',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
