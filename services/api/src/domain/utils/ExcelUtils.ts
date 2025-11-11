import { AttendanceStatusEnum } from "../../common/enum/attendanceStatus.enum";
import { GenderEnum } from "../../common/enum/gender.enum";

/**
 * Dịch trạng thái điểm danh sang tiếng Việt
 */
export const translateStatus = (status?: AttendanceStatusEnum): string => {
  const map: Record<string, string> = {
    Present: "Có mặt",
    AbsentWithLeave: "Vắng có phép",
    Absent: "Vắng không phép",
    Late: "Đi trễ",
    LeftEarly: "Về sớm",
  };
  return map[status ?? ""] || "Không xác định";
};

/**
 * Dịch giới tính
 */
export const translateGender = (gender?: GenderEnum): string => {
  const map: Record<string, string> = {
    Male: "Nam",
    Female: "Nữ",
    Other: "Khác",
  };
  return map[gender ?? ""] || "Không xác định";
};
