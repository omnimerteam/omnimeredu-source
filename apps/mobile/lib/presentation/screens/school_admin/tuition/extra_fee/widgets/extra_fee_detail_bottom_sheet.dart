import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/extra_fee_entity.dart';
import '../bloc/extra_fee_management_bloc.dart';
import '../bloc/extra_fee_management_event.dart';
import '../bloc/extra_fee_management_state.dart';

class ExtraFeeDetailsBottomSheet extends StatelessWidget {
  const ExtraFeeDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtraFeeManagementBloc, ExtraFeeManagementState>(
      builder: (context, state) {
        if (state is ExtraFeeManagementLoaded) {
          if (state.isLoadingDetails) {
            return _buildLoadingContent(context);
          }

          if (state.selectedExtraFee != null) {
            return _buildExtraFeeDetails(context, state.selectedExtraFee!);
          }
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(24),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải thông tin phí phụ...'),
          ],
        ),
      ),
    );
  }

  Widget _buildExtraFeeDetails(BuildContext context, ExtraFeeEntity extraFee) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Thông tin phí phụ',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<ExtraFeeManagementBloc>().add(
                          HideExtraFeeDetailsEvent(),
                        );
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon and basic info
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary.withOpacity(0.1),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.attach_money,
                                size: 40,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  extraFee.name,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      extraFee.active,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _getStatusLabel(extraFee.active),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: _getStatusColor(extraFee.active),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Information sections
                      _buildInfoSection(context, 'Thông tin cơ bản', [
                        _buildInfoItem(
                          context,
                          Icons.attach_money_outlined,
                          'Số tiền',
                          '${extraFee.unitAmount.toStringAsFixed(0)} VNĐ',
                        ),
                        if (extraFee.description?.isNotEmpty == true)
                          _buildInfoItem(
                            context,
                            Icons.description_outlined,
                            'Mô tả',
                            extraFee.description!,
                          ),
                      ]),

                      const SizedBox(height: 24),

                      _buildInfoSection(context, 'Thông tin hệ thống', [
                        _buildInfoItem(
                          context,
                          Icons.access_time_outlined,
                          'Ngày tạo',
                          extraFee.createdAt != null
                              ? AppConstants.dateTimeFormatter.format(
                                  extraFee.createdAt!,
                                )
                              : 'Không có dữ liệu',
                        ),
                        _buildInfoItem(
                          context,
                          Icons.update_outlined,
                          'Cập nhật lần cuối',
                          extraFee.updatedAt != null
                              ? AppConstants.dateTimeFormatter.format(
                                  extraFee.updatedAt!,
                                )
                              : 'Không có dữ liệu',
                        ),
                      ]),

                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Navigate to edit page
                              },
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Chỉnh sửa'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.secondary,
                                foregroundColor: theme.colorScheme.onSecondary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(bool? active) {
    switch (active) {
      case true:
        return Colors.green;
      case false:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(bool? active) {
    switch (active) {
      case true:
        return 'Hoạt động';
      case false:
        return 'Không hoạt động';
      default:
        return 'Không rõ';
    }
  }
}
