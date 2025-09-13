// widgets/class_pagination.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/class_management_bloc.dart';
import '../bloc/class_management_event.dart';
import '../bloc/class_management_state.dart';

class ClassPagination extends StatelessWidget {
  const ClassPagination({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassManagementBloc, ClassManagementState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: state.currentPage > 1
                    ? () {
                        context.read<ClassManagementBloc>().add(
                          ChangePageEvent(state.currentPage - 1),
                        );
                      }
                    : null,
                icon: const Icon(Icons.chevron_left),
                iconSize: 25,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                style: IconButton.styleFrom(
                  backgroundColor: state.currentPage > 1
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  foregroundColor: state.currentPage > 1
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Trang ${state.currentPage}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: state.hasMorePages
                    ? () {
                        context.read<ClassManagementBloc>().add(
                          ChangePageEvent(state.currentPage + 1),
                        );
                      }
                    : null,
                icon: const Icon(Icons.chevron_right),
                iconSize: 25,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                style: IconButton.styleFrom(
                  backgroundColor: state.hasMorePages
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  foregroundColor: state.hasMorePages
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
