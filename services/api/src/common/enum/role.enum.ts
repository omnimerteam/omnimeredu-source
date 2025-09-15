export enum RoleEnum {
  SuperAdmin = "SuperAdmin",
  SchoolAdmin = "SchoolAdmin",
  Teacher = "Teacher",
  Student = "Student",
  CanteenStaff = "CanteenStaff",
  Nurse = "Nurse",
  Security = "Security",
}

// Tuple tự động từ enum TS
export const RoleTuple = Object.values(RoleEnum) as [RoleEnum, ...RoleEnum[]];
