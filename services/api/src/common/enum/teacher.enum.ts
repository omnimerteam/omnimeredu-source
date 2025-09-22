// 🔹 Enum cho qualification
export enum TeacherQualificationEnum {
  DuoiTHSP = "DuoiTHSP",
  TH9_3 = "TH9_3",
  TH12_2 = "TH12_2",
  TrungCap = "TrungCap",
  TrungCapSuPham = "TrungCapSuPham",
  TrungCap_BDNVSP = "TrungCap_BDNVSP",
  CaoDang = "CaoDang",
  CaoDangSuPham = "CaoDangSuPham",
  DaiHoc = "DaiHoc",
  DaiHocSuPham = "DaiHocSuPham",
  ThacSi = "ThacSi",
  TienSi = "TienSi",
  PGS = "PGS",
  GS = "GS",
  BacSiDaKhoa = "BacSiDaKhoa",
  BacSiChuyenKhoa1 = "BacSiChuyenKhoa1",
  BacSiChuyenKhoa2 = "BacSiChuyenKhoa2",
  ChuaQuaDaoTaoSP = "ChuaQuaDaoTaoSP",
  CoChungChiNghe = "CoChungChiNghe",
  TrinhDoKhac = "TrinhDoKhac",
}

// 🔹 Tuple dùng cho Zod hoặc Mongoose enum
export const TeacherQualificationTuple = Object.values(
  TeacherQualificationEnum
) as [TeacherQualificationEnum, ...TeacherQualificationEnum[]];

// 🔹 Enum cho các môn học
export enum SubjectEnum {
  Math = "Math",
  Literature = "Literature",
  English = "English",
  Physics = "Physics",
  Chemistry = "Chemistry",
  Biology = "Biology",
  History = "History",
  Geography = "Geography",
  CivicEducation = "CivicEducation",
  Informatics = "Informatics",
  Technology = "Technology",
  PE = "PE",
  Art = "Art",
  Music = "Musicc",
  NationalDefense = "NationalDefense",
  ExperientialActivities = "ExperientialActivities",
  AdvancedInformatics = "AdvancedInformatics",
  OtherForeignLanguage = "OtherForeignLanguage",
}

// 🔹 Tuple để dùng trong schema validation (Zod hoặc Joi…)
export const SubjectTuple = Object.values(SubjectEnum) as [
  SubjectEnum,
  ...SubjectEnum[]
];
