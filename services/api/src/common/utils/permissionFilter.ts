import { HttpError } from "./HttpError";

export function buildPermissionFilter(userRole: string, schoolId?: string) {
  if (userRole === "SuperAdmin") {
    return {};
  }
  if (userRole === "SchoolAdmin") {
    if (!schoolId) {
      throw new HttpError(400, "Thiếu thông tin trường", "MISSING_SCHOOL_ID");
    }
    return { schoolId };
  }
  throw new HttpError(403, "Bạn không có quyền xem danh sách lớp");
}

export function buildPermissionFilterForStudent(
  userRole: string,
  schoolId?: string
) {
  if (userRole == "SuperAdmin") {
    return {};
  }
  if (userRole == "SchoolAdmin" || userRole == "Teacher") {
    if (!schoolId) {
      throw new HttpError(
        400,
        "Không xác định được thông tin trường",
        "MISSING_SCHOOL_ID"
      );
    }
    return { schoolId };
  }
  throw new HttpError(403, "Bạn không có quyền xem danh sách học sinh");
}

export function buildPermissionFilterForClass(
  userRole: string,
  schoolId?: string
) {
  if (userRole == "SuperAdmin") {
    return {};
  }
  if (userRole == "SchoolAdmin" || userRole == "Teacher") {
    if (!schoolId) {
      throw new HttpError(400, "Thiếu thông tin trường", "MISSING_SCHOOL_ID");
    }
    return { schoolId };
  }
  throw new HttpError(403, "Bạn không có quyền xem danh sách lớp");
}

export function buildPermissionFilterForMemberShipRequest(
  userRole: string,
  schoolId?: string,
  actorId?: string
) {
  if (userRole === "SuperAdmin") {
    return {};
  }
  if (userRole === "SchoolAdmin" && schoolId) {
    return { schoolId };
  }

  return { userId: actorId };
}

// export function permissionToUpdateRoleId(userRole)
