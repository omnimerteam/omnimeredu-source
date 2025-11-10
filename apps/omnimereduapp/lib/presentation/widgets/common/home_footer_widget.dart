import 'package:flutter/material.dart';

class HomeFooterWidget extends StatelessWidget {
  const HomeFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('© 2025 Tập đoàn Omnimer', style: textStyle),
          const SizedBox(width: 12),
          Text('|', style: textStyle),
          const SizedBox(width: 12),
          Text('Liên hệ: contact@omnimer.com', style: textStyle),
        ],
      ),
    );
  }
}
