export enum AttendanceStatus {
  Present = "Present",
  AbsentWithLeave = "AbsentWithLeave",
  Absent = "Absent",
}

// Tuple tự động từ enum TS
export const AttendanceStatusEnum = Object.values(AttendanceStatus) as [
  AttendanceStatus,
  ...AttendanceStatus[]
];
