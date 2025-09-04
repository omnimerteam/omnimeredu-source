import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';

/// Base state cho ClassBloc
abstract class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object?> get props => [];
}

/// State khởi tạo ban đầu
class ClassInitial extends ClassState {}

/// State khi đang tải danh sách lớp
class ClassLoading extends ClassState {}

/// State khi load danh sách lớp thành công
class ClassLoaded extends ClassState {
  final List<ClassSearchEntity> classes;

  const ClassLoaded({required this.classes});

  /// Hỗ trợ copy state khi cần giữ nguyên dữ liệu cũ
  ClassLoaded copyWith({List<ClassSearchEntity>? classes}) {
    return ClassLoaded(classes: classes ?? this.classes);
  }

  @override
  List<Object?> get props => [classes];
}

/// State khi có lỗi xảy ra
class ClassError extends ClassState {
  final String message;

  const ClassError(this.message);

  @override
  List<Object?> get props => [message];
}
