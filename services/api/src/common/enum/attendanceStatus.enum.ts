export enum AttendanceStatusEnum {
  Present = "Present",
  AbsentWithLeave = "AbsentWithLeave",
  Absent = "Absent",
}

// Tuple tự động từ enum TS
export const AttendanceStatusTuple = Object.values(AttendanceStatusEnum) as [
  AttendanceStatusEnum,
  ...AttendanceStatusEnum[]
];
