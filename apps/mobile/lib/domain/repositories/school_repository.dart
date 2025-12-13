import '../../core/errors/failures.dart';
import '../../core/typedefs.dart';
import '../../core/constants/enum_constant.dart';
import '../entities/school/school_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SchoolRepository {
  FutureResult<List<SchoolEntity>> getSchoolsByLevel(EducationSystemLevelsEnum level);
}