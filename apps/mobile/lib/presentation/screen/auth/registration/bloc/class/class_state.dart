import 'package:equatable/equatable.dart';
import '../../../../../../domain/entities/school/class_selector_entity.dart';

/// Base state cho ClassBloc
abstract class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object?> get props => [];
}

/// State khởi tạo
class ClassInitial extends ClassState {
  const ClassInitial();
}

/// State khi đang tải danh sách lớp
class ClassLoading extends ClassState {
  const ClassLoading();
}

/// State khi tải thành công danh sách lớp
class ClassLoaded extends ClassState {
  final List<ClassSelectorEntity> classes;

  const ClassLoaded({required this.classes});

  @override
  List<Object?> get props => [classes];
}

/// State khi có lỗi
class ClassError extends ClassState {
  final String message;

  const ClassError(this.message);

  @override
  List<Object?> get props => [message];
}
