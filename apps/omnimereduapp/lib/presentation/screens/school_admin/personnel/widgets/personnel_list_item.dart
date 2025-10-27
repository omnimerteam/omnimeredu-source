import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_constant.dart';
import '../../../../utils/display_mapper.dart';
import '../../../../widgets/dialog/delete_confirm_dialog.dart';
import '../../../../../domain/entities/user/personnel_entity.dart';
import '../../../../widgets/dialog/suspension_confirmation_dialog.dart';
import '../bloc/personnel_management_bloc.dart';
import '../bloc/personnel_management_event.dart';

class PersonnelListItem extends StatelessWidget {
  final PersonnelEntity personnel;

  const PersonnelListItem({super.key, required this.personnel});

  String _calculateAge(DateTime? birthday) {
    if (birthday == null) return '';
    final now = DateTime.now();
    int age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age -= 1;
    }
    return '($age tuổi)';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar + Status
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    personnel.fullName.isNotEmpty
                        ? personnel.fullName.substring(0, 1).toUpperCase()
                        : '?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (!personnel.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Personnel info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Role
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        personnel.fullName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(
                          personnel.roleKey,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        DisplayMapper.personnelName(personnel.roleName),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getRoleColor(personnel.roleKey),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Email
                if (personnel.email?.isNotEmpty == true)
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          personnel.email!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.8),
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                // Birthday + Age
                Row(
                  children: [
                    Icon(
                      Icons.cake_outlined,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      personnel.birthday != null
                          ? '${AppConstants.dateFormatter.format(personnel.birthday!)} ${_calculateAge(personnel.birthday!)}'
                          : 'Không có dữ liệu',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Phone
                if (personnel.phone?.isNotEmpty == true)
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        personnel.phone!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),

                // Gender
                if (personnel.gender != null)
                  Row(
                    children: [
                      Icon(
                        personnel.gender == 'Male' ? Icons.male : Icons.female,
                        size: 16,
                        color: personnel.gender == 'Male'
                            ? Colors.blue
                            : Colors.pink,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DisplayMapper.genderName(personnel.gender),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: personnel.gender == 'Male'
                              ? Colors.blue
                              : Colors.pink,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Action menu
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'view_details',
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const Text('Xem chi tiết'),
                  ],
                ),
              ),
              if (personnel.isSchoolAdmin || personnel.isTeacher)
                PopupMenuItem(
                  value: 'assign_work',
                  child: Row(
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 12),
                      const Text('Giao việc'),
                    ],
                  ),
                ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'suspend',
                child: Row(
                  children: [
                    Icon(Icons.pause_outlined, size: 18, color: Colors.orange),
                    const SizedBox(width: 12),
                    Text(
                      personnel.isVerified
                          ? 'Đình chỉ công tác'
                          : 'Khôi phục công tác',
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'dismiss',
                child: Row(
                  children: [
                    Icon(
                      Icons.remove_circle_outline,
                      size: 18,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    const Text('Đuổi việc'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String roleKey) {
    switch (roleKey) {
      case 'SchoolAdmin':
        return Colors.purple;
      case 'Teacher':
        return Colors.blue;
      case 'Security':
        return Colors.green;
      case 'Nurse':
        return Colors.red;
      case 'CanteenStaff':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _handleMenuAction(BuildContext context, String action) {
    final bloc = context.read<PersonnelManagementBloc>();
    switch (action) {
      case 'view_details':
        bloc.add(ShowPersonnelDetailsEvent(personnel));
        break;
      case 'assign_work':
        bloc.add(ShowAssignmentDialogEvent(personnel));
        break;
      case 'suspend':
        _showConfirmStatusChange(context);
        break;
      case 'dismiss':
        _showConfirmDismiss(context);
        break;
    }
  }

  void _showConfirmStatusChange(BuildContext context) {
    final bloc = context.read<PersonnelManagementBloc>();
    final isSuspending = personnel.isVerified;
    showDialog(
      context: context,
      builder: (_) => SuspensionConfirmationDialog(
        title: isSuspending ? 'Đình chỉ công tác' : 'Khôi phục công tác',
        message:
            'Bạn có chắc chắn muốn ${isSuspending ? 'đình chỉ' : 'khôi phục'} công tác cho "${personnel.fullName}"?',
        onConfirm: () {
          bloc.add(
            UpdatePersonnelStatusEvent(
              personnelId: personnel.id!,
              isVerified: !personnel.isVerified,
            ),
          );
        },
        confirmTitle: isSuspending ? 'Đình chỉ' : "Khôi phục",
      ),
    );
  }

  void _showConfirmDismiss(BuildContext context) {
    final bloc = context.read<PersonnelManagementBloc>();
    showDialog(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        title: 'Đuổi việc',
        message:
            'Bạn có chắc chắn muốn đuổi việc "${personnel.fullName}"?\nHành động này không thể hoàn tác.',
        onConfirm: () {
          bloc.add(DismissPersonnelEvent(personnel));
        },
      ),
    );
  }
}
