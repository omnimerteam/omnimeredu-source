import 'package:equatable/equatable.dart';
import 'package:mobile/domain/entities/grade/grade_entity.dart';

abstract class GradeManagementEvent extends Equatable {
  const GradeManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadGradesEvent extends GradeManagementEvent {
  const LoadGradesEvent();
}

class RefreshGradesEvent extends GradeManagementEvent {
  const RefreshGradesEvent();
}

class LoadMoreGradesEvent extends GradeManagementEvent {
  const LoadMoreGradesEvent();
}

class FilterGradesEvent extends GradeManagementEvent {
  final Map<String, dynamic> filter;
  const FilterGradesEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SortGradesEvent extends GradeManagementEvent {
  final List<Map<String, String>> sort;
  const SortGradesEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}

class CreateGradeEvent extends GradeManagementEvent {
  final GradeEntity gradeEntity;
  const CreateGradeEvent(this.gradeEntity);

  @override
  List<Object?> get props => [gradeEntity];
}

class UpdateGradeEvent extends GradeManagementEvent {
  final GradeEntity gradeEntity;
  const UpdateGradeEvent(this.gradeEntity);

  @override
  List<Object?> get props => [gradeEntity];
}

class DeleteGradeEvent extends GradeManagementEvent {
  final String gradeId;
  const DeleteGradeEvent(this.gradeId);

  @override
  List<Object?> get props => [gradeId];
}

class LoadGradeForEditEvent extends GradeManagementEvent {
  final GradeEntity gradeToEdit;
  const LoadGradeForEditEvent(this.gradeToEdit);

  @override
  List<Object?> get props => [gradeToEdit];
}

class ShowCreateFormEvent extends GradeManagementEvent {
  const ShowCreateFormEvent();
}

class HideFormEvent extends GradeManagementEvent {
  const HideFormEvent();
}

class ResetFormEvent extends GradeManagementEvent {
  const ResetFormEvent();
}

class ClearFormDataEvent extends GradeManagementEvent {
  const ClearFormDataEvent();
}
