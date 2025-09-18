enum EducationSystemLevelsEnum {
  Preschool,
  Primary,
  Secondary,
  HighSchool,
  University,
}

/// 🔧 Extension giúp convert String <-> Enum
extension EducationSystemLevelsEnumX on EducationSystemLevelsEnum {
  /// Convert enum -> String (sẵn có trong Dart >= 2.15)
  String get asString => name;

  /// Convert String -> Enum
  static EducationSystemLevelsEnum fromString(String value) {
    return EducationSystemLevelsEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EducationSystemLevelsEnum.Preschool,
    );
  }
}
