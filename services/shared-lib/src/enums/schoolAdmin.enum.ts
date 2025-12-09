// 🔹 Enum cho vị trí quản trị trường
export enum SchoolAdminPositionEnum {
  HieuTruong = "HieuTruong",
  PhoHieuTruong = "PhoHieuTruong",
  TruongPhongDaoTao = "TruongPhongDaoTao",
  PhoPhongDaoTao = "PhoPhongDaoTao",
  TruongPhongHanhChinh = "TruongPhongHanhChinh",
  PhoPhongHanhChinh = "PhoPhongHanhChinh",
  KeToanTruong = "KeToanTruong",
  ThuQuy = "ThuQuy",
  TruongBanCNTT = "TruongBanCNTT",
  PhoBanCNTT = "PhoBanCNTT",

  // 🔹 Nhóm sáng lập / cổ đông
  Founder = "Founder",
  CoFounder = "CoFounder",
  Owner = "Owner",

  None = "None",
}

// 🔹 Tuple để dùng trong schema validation (Zod, Joi, Mongoose enum…)
export const SchoolAdminPositionTuple = Object.values(
  SchoolAdminPositionEnum
) as [SchoolAdminPositionEnum, ...SchoolAdminPositionEnum[]];
