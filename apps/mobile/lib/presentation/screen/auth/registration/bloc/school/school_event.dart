import 'package:equatable/equatable.dart';
import '../../../../../../core/constants/enum_constant.dart';

/// Base event cho SchoolBloc
abstract class SchoolEvent extends Equatable {
  const SchoolEvent();

  @override
  List<Object?> get props => [];
}

/// Event để load danh sách trường theo cấp độ (level)
class LoadSchoolsByLevel extends SchoolEvent {
  final EducationSystemLevelsEnum level;

  const LoadSchoolsByLevel(this.level);

  @override
  List<Object?> get props => [level];
}
