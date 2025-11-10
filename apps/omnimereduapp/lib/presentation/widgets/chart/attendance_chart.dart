import 'package:flutter/material.dart';
import '../../../domain/entities/dashboard/school_admin/attendance_stats_entity.dart';

class AttendanceChart extends StatelessWidget {
  final List<ClassStatsEntity> classStats;

  const AttendanceChart({Key? key, required this.classStats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Điểm danh hôm nay theo lớp',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildLegend(context),
              const SizedBox(height: 20),

              // ✅ Nếu rỗng -> hiển thị thông báo
              if (classStats.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Không có dữ liệu',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...classStats.take(10).map((stat) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildClassCard(context, stat),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildLegendItem(context, 'Có mặt', Colors.green),
        _buildLegendItem(context, 'Nghỉ phép', Colors.blue),
        _buildLegendItem(context, 'Vắng', Colors.red),
        _buildLegendItem(context, 'Muộn', Colors.orange),
        _buildLegendItem(context, 'Về sớm', Colors.purple),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 11,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildClassCard(BuildContext context, ClassStatsEntity stat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                stat.className,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Tổng: ${stat.total}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Thanh progress bar xếp chồng
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 12,
            child: Stack(
              children: [
                // Background
                Container(width: double.infinity, color: Colors.grey[200]),
                // Các phần xếp chồng
                Row(
                  children: [
                    if (stat.present > 0)
                      _buildProgressSegment(
                        stat.present / stat.total,
                        Colors.green,
                      ),
                    if (stat.absentWithLeave > 0)
                      _buildProgressSegment(
                        stat.absentWithLeave / stat.total,
                        Colors.blue,
                      ),
                    if (stat.late > 0)
                      _buildProgressSegment(
                        stat.late / stat.total,
                        Colors.orange,
                      ),
                    if (stat.leftEarly > 0)
                      _buildProgressSegment(
                        stat.leftEarly / stat.total,
                        Colors.purple,
                      ),
                    if (stat.absent > 0)
                      _buildProgressSegment(
                        stat.absent / stat.total,
                        Colors.red,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Chi tiết số liệu
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            if (stat.present > 0)
              _buildStatChip(context, 'Có mặt', stat.present, Colors.green),
            if (stat.absentWithLeave > 0)
              _buildStatChip(
                context,
                'Nghỉ phép',
                stat.absentWithLeave,
                Colors.blue,
              ),
            if (stat.late > 0)
              _buildStatChip(context, 'Muộn', stat.late, Colors.orange),
            if (stat.leftEarly > 0)
              _buildStatChip(context, 'Về sớm', stat.leftEarly, Colors.purple),
            if (stat.absent > 0)
              _buildStatChip(context, 'Vắng', stat.absent, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSegment(double ratio, Color color) {
    return Flexible(
      flex: (ratio * 100).round(),
      child: Container(height: double.infinity, color: color),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          Text(
            '$count',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
