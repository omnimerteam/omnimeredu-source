import 'package:equatable/equatable.dart';

class ClassDetailViewEntity extends Equatable {
  final String? id;
  final String? name;
  final String? code;
  final int? baseFee;
  final int? studentCount;
  final String? schoolId;
  final String? schoolName;
  final String? schoolLevel;
  final String? mainTeacherId;
  final String? mainTeacherName;

  const ClassDetailViewEntity({
    this.id,
    this.name,
    this.code,
    this.baseFee,
    this.studentCount,
    this.schoolId,
    this.schoolName,
    this.schoolLevel,
    this.mainTeacherId,
    this.mainTeacherName,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    baseFee,
    studentCount,
    schoolId,
    schoolName,
    schoolLevel,
    mainTeacherId,
    mainTeacherName,
  ];
}

// _id: Types.ObjectId;
//   name: string;
//   code: string;
//   baseFee: number;
//   studentCount: number;
//   schoolId: Types.ObjectId;
//   schoolName: string;
//   schoolLevel: string;
//   mainTeacherId: Types.ObjectId;
//   mainTeacherName: string;
