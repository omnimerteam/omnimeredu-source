export enum AttendanceStatusEnum {
  Present = "Present",
  AbsentWithLeave = "AbsentWithLeave",
  Absent = "Absent",
  Late = "Late",
  LeftEarly = "LeftEarly",
}

// Tuple tự động từ enum TS
export const AttendanceStatusTuple = Object.values(AttendanceStatusEnum) as [
  AttendanceStatusEnum,
  ...AttendanceStatusEnum[]
];

export enum AttendanceSessionTypeEnum {
  regular = "regular",
  weekend = "weekend",
  holiday = "holiday",
  extra = "extra",
}

// Tuple tự động từ enum TS
export const AttendanceAttendanceSessionTypeTuple = Object.values(
  AttendanceSessionTypeEnum
) as [AttendanceSessionTypeEnum, ...AttendanceSessionTypeEnum[]];
