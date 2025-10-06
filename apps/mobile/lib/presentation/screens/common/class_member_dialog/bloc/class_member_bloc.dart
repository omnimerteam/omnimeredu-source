import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_selector_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/add_student_to_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/remove_student_from_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/transfer_class_use_case.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/student/get_student_selector_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_state.dart';

class ClassMemberBloc extends Bloc<ClassMemberEvent, ClassMemberState> {
  final GetStudentSelectorUseCase getStudentSelectorUseCase;
  final AddStudentToClassUseCase addStudentToClassUseCase;
  final RemoveStudentFromClassUseCase removeStudentFromClassUseCase;
  final TransferClassUseCase transferClassUseCase;

  ClassMemberBloc({
    required this.getStudentSelectorUseCase,
    required this.addStudentToClassUseCase,
    required this.removeStudentFromClassUseCase,
    required this.transferClassUseCase,
  }) : super(const ClassMemberInitial()) {
    on<LoadStudents>(_onLoadStudents);
    on<ToggleStudentSelection>(_onToggleStudentSelection);
    on<ToggleSelectAll>(_onToggleSelectAll);
    on<ChangeMemberMode>(_onChangeMemberMode);
    on<SelectClass>(_onSelectClass);
    on<SelectTargetClass>(_onSelectTargetClass);
    on<ChangeSearchQuery>(_onChangeSearchQuery);
    on<SubmitClassMember>(_onSubmitClassMember);
    on<ResetClassMember>(_onResetClassMember);
  }

  Future<void> _onLoadStudents(
    LoadStudents event,
    Emitter<ClassMemberState> emit,
  ) async {
    emit(const ClassMemberLoading());

    try {
      final response = await getStudentSelectorUseCase.call(event.gradeId);

      if (response.data != null) {
        var students = response.data!;

        // Lọc theo mode
        students = _filterStudentsByMode(
          students,
          event.mode,
          event.currentClassId,
        );

        emit(
          ClassMemberLoaded(
            allStudents: students,
            filteredStudents: students,
            selectedStudentIds: {},
            mode: event.mode,
            selectedClassId: event.currentClassId,
          ),
        );
      } else {
        emit(
          ClassMemberError(
            response.message ?? 'Không thể tải danh sách học sinh',
          ),
        );
      }
    } catch (e) {
      logger.e('Load students error: $e');
      emit(ClassMemberError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  List<StudentSelectorEntity> _filterStudentsByMode(
    List<StudentSelectorEntity> students,
    ClassMemberMode mode,
    String? classId,
  ) {
    switch (mode) {
      case ClassMemberMode.add:
        // Chỉ hiển thị học sinh chưa có lớp hoặc chưa verified
        return students
            .where((s) => s.classId == null || !s.isVerified)
            .toList();

      case ClassMemberMode.remove:
        // Chỉ hiển thị học sinh trong lớp hiện tại
        if (classId == null) return [];
        return students.where((s) => s.classId == classId).toList();

      case ClassMemberMode.transfer:
        // Chỉ hiển thị học sinh trong lớp hiện tại
        if (classId == null) return [];
        return students.where((s) => s.classId == classId).toList();
    }
  }

  void _onToggleStudentSelection(
    ToggleStudentSelection event,
    Emitter<ClassMemberState> emit,
  ) {
    if (state is ClassMemberLoaded) {
      final currentState = state as ClassMemberLoaded;
      final newSelectedIds = Set<String>.from(currentState.selectedStudentIds);

      if (newSelectedIds.contains(event.studentId)) {
        newSelectedIds.remove(event.studentId);
      } else {
        newSelectedIds.add(event.studentId);
      }

      emit(currentState.copyWith(selectedStudentIds: newSelectedIds));
    }
  }

  void _onToggleSelectAll(
    ToggleSelectAll event,
    Emitter<ClassMemberState> emit,
  ) {
    if (state is ClassMemberLoaded) {
      final currentState = state as ClassMemberLoaded;
      final allIds = currentState.filteredStudents.map((s) => s.id).toSet();
      final isAllSelected =
          currentState.selectedStudentIds.length == allIds.length;

      emit(
        currentState.copyWith(selectedStudentIds: isAllSelected ? {} : allIds),
      );
    }
  }

  void _onChangeMemberMode(
    ChangeMemberMode event,
    Emitter<ClassMemberState> emit,
  ) {
    if (state is ClassMemberLoaded) {
      final currentState = state as ClassMemberLoaded;

      // Lọc lại students theo mode mới
      final filteredStudents = _filterStudentsByMode(
        currentState.allStudents,
        event.mode,
        currentState.selectedClassId,
      );

      emit(
        currentState.copyWith(
          mode: event.mode,
          filteredStudents: filteredStudents,
          selectedStudentIds: {},
          targetClassId: null,
        ),
      );
    }
  }

  void _onSelectClass(SelectClass event, Emitter<ClassMemberState> emit) {
    if (state is ClassMemberLoaded) {
      final currentState = state as ClassMemberLoaded;

      // Lọc lại students theo class mới
      final filteredStudents = _filterStudentsByMode(
        currentState.allStudents,
        currentState.mode,
        event.classId,
      );

      emit(
        currentState.copyWith(
          selectedClassId: event.classId,
          filteredStudents: filteredStudents,
          selectedStudentIds: {},
        ),
      );
    }
  }

  void _onSelectTargetClass(
    SelectTargetClass event,
    Emitter<ClassMemberState> emit,
  ) {
    if (state is ClassMemberLoaded) {
      final currentState = state as ClassMemberLoaded;
      emit(currentState.copyWith(targetClassId: event.targetClassId));
    }
  }

  void _onChangeSearchQuery(
    ChangeSearchQuery event,
    Emitter<ClassMemberState> emit,
  ) {
    if (state is ClassMemberLoaded) {
      final currentState = state as ClassMemberLoaded;
      final query = event.query.toLowerCase().trim();

      var filtered = _filterStudentsByMode(
        currentState.allStudents,
        currentState.mode,
        currentState.selectedClassId,
      );

      if (query.isNotEmpty) {
        filtered = filtered.where((s) {
          return s.fullName.toLowerCase().contains(query) ||
              s.id.toLowerCase().contains(query);
        }).toList();
      }

      emit(
        currentState.copyWith(
          searchQuery: event.query,
          filteredStudents: filtered,
        ),
      );
    }
  }

  Future<void> _onSubmitClassMember(
    SubmitClassMember event,
    Emitter<ClassMemberState> emit,
  ) async {
    if (state is! ClassMemberLoaded) return;

    final currentState = state as ClassMemberLoaded;

    if (!currentState.canSubmit) return;

    emit(currentState.copyWith(isSubmitting: true));

    try {
      final studentIds = currentState.selectedStudentIds.toList();

      switch (currentState.mode) {
        case ClassMemberMode.add:
          final response = await addStudentToClassUseCase.call(
            currentState.selectedClassId!,
            studentIds,
          );

          if (response.data != null) {
            emit(
              ClassMemberSuccess(
                message: 'Thêm học sinh vào lớp thành công',
                successCount: response.data!.addedCount,
                failedCount: response.data!.failedCount,
              ),
            );
          } else {
            emit(
              ClassMemberError(response.message ?? 'Thêm học sinh thất bại'),
            );
          }
          break;

        case ClassMemberMode.remove:
          final response = await removeStudentFromClassUseCase.call(
            currentState.selectedClassId!,
            studentIds,
          );

          if (response.success) {
            emit(
              ClassMemberSuccess(
                message: 'Rút học sinh khỏi lớp thành công',
                successCount: studentIds.length,
                failedCount: 0,
              ),
            );
          } else {
            emit(ClassMemberError(response.message ?? 'Rút học sinh thất bại'));
          }
          break;

        case ClassMemberMode.transfer:
          final response = await transferClassUseCase.transferClass(
            currentState.selectedClassId!,
            currentState.targetClassId!,
            studentIds,
          );

          if (response.data != null) {
            emit(
              ClassMemberSuccess(
                message: 'Chuyển lớp cho học sinh thành công',
                successCount: response.data!.transferred,
                failedCount: response.data!.failedCount,
              ),
            );
          } else {
            emit(ClassMemberError(response.message ?? 'Chuyển lớp thất bại'));
          }
          break;
      }
    } catch (e) {
      logger.e('Submit class member error: $e');
      emit(ClassMemberError('Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  void _onResetClassMember(
    ResetClassMember event,
    Emitter<ClassMemberState> emit,
  ) {
    emit(const ClassMemberInitial());
  }
}
