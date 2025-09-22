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
// 🔹 Grades / lớp cụ thể theo từng bậc học
export enum EducationGradesEnum {
  // Mầm non
  Nursery = "Nursery",
  Preschool_Baby = "Preschool_Baby",
  Preschool_Middle = "Preschool_Middle",
  Preschool_Large = "Preschool_Large",

  // Tiểu học
  Primary_1 = "Primary_1",
  Primary_2 = "Primary_2",
  Primary_3 = "Primary_3",
  Primary_4 = "Primary_4",
  Primary_5 = "Primary_5",

  // Trung học cơ sở
  Secondary_6 = "Secondary_6",
  Secondary_7 = "Secondary_7",
  Secondary_8 = "Secondary_8",
  Secondary_9 = "Secondary_9",

  // Trung học phổ thông
  HighSchool_10 = "HighSchool_10",
  HighSchool_11 = "HighSchool_11",
  HighSchool_12 = "HighSchool_12",

  // Đại học
  University_1 = "University_1",
  University_2 = "University_2",
  University_3 = "University_3",
  University_4 = "University_4",
  University_5 = "University_5",
}

// Tuple cho Mongoose enum
export const EducationGradesTuple = Object.values(EducationGradesEnum) as [
  EducationGradesEnum,
  ...EducationGradesEnum[]
];

// 🔹 Map ánh xạ cấp học → grade
const GradesByLevel: Record<EducationSystemLevelsEnum, EducationGradesEnum[]> =
  {
    [EducationSystemLevelsEnum.Preschool]: [
      EducationGradesEnum.Nursery,
      EducationGradesEnum.Preschool_Baby,
      EducationGradesEnum.Preschool_Middle,
      EducationGradesEnum.Preschool_Large,
    ],
    [EducationSystemLevelsEnum.Primary]: [
      EducationGradesEnum.Primary_1,
      EducationGradesEnum.Primary_2,
      EducationGradesEnum.Primary_3,
      EducationGradesEnum.Primary_4,
      EducationGradesEnum.Primary_5,
    ],
    [EducationSystemLevelsEnum.Secondary]: [
      EducationGradesEnum.Secondary_6,
      EducationGradesEnum.Secondary_7,
      EducationGradesEnum.Secondary_8,
      EducationGradesEnum.Secondary_9,
    ],
    [EducationSystemLevelsEnum.HighSchool]: [
      EducationGradesEnum.HighSchool_10,
      EducationGradesEnum.HighSchool_11,
      EducationGradesEnum.HighSchool_12,
    ],
    [EducationSystemLevelsEnum.University]: [
      EducationGradesEnum.University_1,
      EducationGradesEnum.University_2,
      EducationGradesEnum.University_3,
      EducationGradesEnum.University_4,
      EducationGradesEnum.University_5,
    ],
  };

// 🔹 Helper lấy danh sách grade theo cấp học
export const getGradesForLevel = (level: EducationSystemLevelsEnum) =>
  GradesByLevel[level] ?? [];
