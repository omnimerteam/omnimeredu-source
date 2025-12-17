import 'package:equatable/equatable.dart';

class StudentDetailRecordEntity extends Equatable {
  final String id;
  final String name;
  final String gender;
  final String? phone;
  final String guardianName;
  final String guardianPhone;

  const StudentDetailRecordEntity({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    required this.guardianName,
    required this.guardianPhone,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    gender,
    phone,
    guardianName,
    guardianPhone,
  ];
}
