class SchoolDataEntity {
  final String name;
  final String code;
  final String address;
  final String
  level; // Preschool | Primary | Secondary | HighSchool | University
  final String? logoUrl;

  SchoolDataEntity({
    required this.name,
    required this.code,
    required this.address,
    required this.level,
    this.logoUrl,
  });
}
