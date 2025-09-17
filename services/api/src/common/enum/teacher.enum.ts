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
  Math = "Toán",
  Literature = "Ngữ văn",
  English = "Tiếng Anh",
  Physics = "Vật lý",
  Chemistry = "Hóa học",
  Biology = "Sinh học",
  History = "Lịch sử",
  Geography = "Địa lý",
  CivicEducation = "Giáo dục công dân",
  Informatics = "Tin học",
  Technology = "Công nghệ",
  PE = "Thể dục",
  Art = "Mỹ thuật",
  Music = "Âm nhạc",
  NationalDefense = "Giáo dục quốc phòng - an ninh",
  ExperientialActivities = "Hoạt động trải nghiệm",
  AdvancedInformatics = "Tin học (Lập trình nâng cao)",
  OtherForeignLanguage = "Ngoại ngữ khác",
}

// 🔹 Tuple để dùng trong schema validation (Zod hoặc Joi…)
export const SubjectTuple = Object.values(SubjectEnum) as [
  SubjectEnum,
  ...SubjectEnum[]
];
