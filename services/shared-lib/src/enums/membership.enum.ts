/**
 * 🔹 Enum cho vai trò
 */
export enum MembershipRoleEnum {
  Student = "Student",
  Teacher = "Teacher",
  Staff = "Staff",
  SchoolAdmin = "SchoolAdmin",
}

export const MembershipRoleTuple = Object.values(MembershipRoleEnum) as [
  MembershipRoleEnum,
  ...MembershipRoleEnum[]
];

/**
 * 🔹 Enum cho hành động
 */
export enum MembershipActionEnum {
  Enroll = "Enroll", // Nhập học / Nhận công tác
  Transfer = "Transfer", // Chuyển lớp
  Assign = "Assign", // Phân công giảng dạy / làm việc
  Resign = "Resign", // Nghỉ học / Thôi công tác
}

export const MembershipActionTuple = Object.values(MembershipActionEnum) as [
  MembershipActionEnum,
  ...MembershipActionEnum[]
];

/**
 * 🔹 Enum cho trạng thái
 */
export enum MembershipStatusEnum {
  Pending = "Pending",
  Approved = "Approved",
  Rejected = "Rejected",
}

export const MembershipStatusTuple = Object.values(MembershipStatusEnum) as [
  MembershipStatusEnum,
  ...MembershipStatusEnum[]
];
