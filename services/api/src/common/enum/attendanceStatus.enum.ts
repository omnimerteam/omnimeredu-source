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

// ================== QR ATTENDANCE ENUMS ==================

// Method of attendance (QR scan or manual by teacher)
export enum AttendanceMethodEnum {
  QR = "QR",
  Manual = "MANUAL",
}

export const AttendanceMethodTuple = Object.values(AttendanceMethodEnum) as [
  AttendanceMethodEnum,
  ...AttendanceMethodEnum[]
];

// Result status of QR scan
export enum ScanStatusEnum {
  Success = "success",
  Expired = "expired",
  OutOfRange = "out_of_range",
  InvalidQR = "invalid_qr",
  AlreadyScanned = "already_scanned",
  Error = "error",
}

export const ScanStatusTuple = Object.values(ScanStatusEnum) as [
  ScanStatusEnum,
  ...ScanStatusEnum[]
];
