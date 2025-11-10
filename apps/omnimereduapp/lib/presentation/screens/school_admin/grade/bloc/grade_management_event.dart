import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/grade/grade_entity.dart';

abstract class GradeManagementEvent extends Equatable {
  const GradeManagementEvent();

  @override
  List<Object?> get props => [];
}

/// Load initial grades
class LoadGradesEvent extends GradeManagementEvent {
  const LoadGradesEvent();
}

/// Refresh current grades list
class RefreshGradesEvent extends GradeManagementEvent {
  const RefreshGradesEvent();
}

/// Load more grades (pagination)
class LoadMoreGradesEvent extends GradeManagementEvent {
  const LoadMoreGradesEvent();
}

/// Apply filter
class FilterGradesEvent extends GradeManagementEvent {
  final Map<String, dynamic> filter;

  const FilterGradesEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Apply sort
class SortGradesEvent extends GradeManagementEvent {
  final List<Map<String, String>> sort;

  const SortGradesEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}

/// Create new grade
class CreateGradeEvent extends GradeManagementEvent {
  final GradeEntity gradeEntity;

  const CreateGradeEvent(this.gradeEntity);

  @override
  List<Object?> get props => [gradeEntity];
}

/// Update existing grade
class UpdateGradeEvent extends GradeManagementEvent {
  final GradeEntity gradeEntity;

  const UpdateGradeEvent(this.gradeEntity);

  @override
  List<Object?> get props => [gradeEntity];
}

/// Delete grade
class DeleteGradeEvent extends GradeManagementEvent {
  final String gradeId;

  const DeleteGradeEvent(this.gradeId);

  @override
  List<Object?> get props => [gradeId];
}

/// Load grade for editing
class LoadGradeForEditEvent extends GradeManagementEvent {
  final GradeEntity? gradeToEdit;

  const LoadGradeForEditEvent(this.gradeToEdit);

  @override
  List<Object?> get props => [gradeToEdit];
}

/// Show create form
class ShowCreateFormEvent extends GradeManagementEvent {
  const ShowCreateFormEvent();
}

/// Hide form
class HideFormEvent extends GradeManagementEvent {
  const HideFormEvent();
}

/// Reset form to initial state
class ResetFormEvent extends GradeManagementEvent {
  const ResetFormEvent();
}

/// Clear form data
class ClearFormDataEvent extends GradeManagementEvent {
  const ClearFormDataEvent();
}
