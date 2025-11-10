import 'package:flutter/material.dart';

class AttendanceStatsCard extends StatelessWidget {
  final Map<String, int> stats;

  const AttendanceStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // List trạng thái và màu theo semantic colors
    final statItems = [
      _StatItem(
        'Có mặt',
        stats['present'] ?? 0,
        theme.colorScheme.tertiary,
      ), // success
      _StatItem('Vắng', stats['absent'] ?? 0, theme.colorScheme.error),
      _StatItem('Đi trễ', stats['late'] ?? 0, Colors.orangeAccent),
      _StatItem(
        'Vắng có phép',
        stats['absentWithLeave'] ?? 0,
        theme.colorScheme.secondary,
      ),
      _StatItem('Về sớm', stats['leftEarly'] ?? 0, Colors.purpleAccent),
    ];

    return Card(
      margin: EdgeInsets.zero,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tổng quan
            Text(
              'Tổng số học sinh: ${stats['total'] ?? 0}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            // Thống kê chi tiết
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: statItems
                  .map((item) => _buildStatTile(context, item))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(BuildContext context, _StatItem item) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${item.label}: ${item.count}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: item.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String label;
  final int count;
  final Color color;

  _StatItem(this.label, this.count, this.color);
}
