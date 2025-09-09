export enum EducationSystemLevelsEnum {
  Preschool = "Preschool",
  Primary = "Primary",
  Secondary = "Secondary",
  HighSchool = "HighSchool",
  University = "University",
}

// Tuple tự động từ enum TS
export const EducationSystemLevelsTuple = Object.values(
  EducationSystemLevelsEnum
) as [EducationSystemLevelsEnum, ...EducationSystemLevelsEnum[]];
