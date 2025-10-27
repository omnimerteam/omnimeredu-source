import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/class/class_search_entity.dart';

/// Base state cho ClassSelectorBloc
abstract class ClassSelectorState extends Equatable {
  const ClassSelectorState();

  @override
  List<Object?> get props => [];
}

/// State khởi tạo ban đầu
class ClassSelectorInitial extends ClassSelectorState {}

/// State khi đang tải danh sách lớp
class ClassSelectorLoading extends ClassSelectorState {}

/// State khi load danh sách lớp thành công
class ClassSelectorLoaded extends ClassSelectorState {
  final List<ClassSearchEntity> classes;

  const ClassSelectorLoaded({required this.classes});

  /// copyWith để giữ nguyên data cũ
  ClassSelectorLoaded copyWith({List<ClassSearchEntity>? classes}) {
    return ClassSelectorLoaded(classes: classes ?? this.classes);
  }

  @override
  List<Object?> get props => [classes];
}

/// State khi có lỗi xảy ra
class ClassSelectorError extends ClassSelectorState {
  final String message;

  const ClassSelectorError(this.message);

  @override
  List<Object?> get props => [message];
}
