import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school/school_search_entity.dart';

/// Base state cho SchoolBloc
abstract class SchoolState extends Equatable {
  const SchoolState();

  @override
  List<Object?> get props => [];
}

/// State khởi tạo
class SchoolInitial extends SchoolState {
  const SchoolInitial();
}

/// State khi đang tải danh sách trường
class SchoolLoading extends SchoolState {
  const SchoolLoading();
}

/// State khi tải thành công danh sách trường
class SchoolLoaded extends SchoolState {
  final List<SchoolSearchEntity> schools;

  const SchoolLoaded({required this.schools});

  @override
  List<Object?> get props => [schools];
}

/// State khi có lỗi
class SchoolError extends SchoolState {
  final String message;

  const SchoolError(this.message);

  @override
  List<Object?> get props => [message];
}
