import dayjs from "dayjs";
import { AttendanceSessionTypeEnum } from "../../common/enum/attendanceStatus.enum"; // đường dẫn model holiday
import { Types } from "mongoose";
import Holiday from "../models/system/Holiday";

/**
 * Xác định loại buổi học (sessionType) cho 1 ngày cụ thể
 * @param date - Ngày cần kiểm tra
 * @param schoolId - ID của trường (để lấy ngày lễ riêng)
 */
export async function determineSessionType(
  date: Date,
  schoolId?: Types.ObjectId
): Promise<AttendanceSessionTypeEnum> {
  const dayOfWeek = dayjs(date).day(); // 0 = CN, 6 = Thứ 7

  // --- 1️⃣ Nếu là Thứ 7 hoặc Chủ nhật
  if (dayOfWeek === 0 || dayOfWeek === 6) {
    return AttendanceSessionTypeEnum.weekend;
  }

  // --- 2️⃣ Nếu là ngày nghỉ lễ (toàn quốc hoặc của trường)
  const holiday = await findHoliday(date, schoolId);
  if (holiday) {
    return AttendanceSessionTypeEnum.holiday;
  }

  // --- 3️⃣ Nếu là buổi học bù (ExtraSession)
  const extra = await isExtraSession(date, schoolId);
  if (extra) {
    return AttendanceSessionTypeEnum.extra;
  }

  // --- 4️⃣ Mặc định là ngày học bình thường
  return AttendanceSessionTypeEnum.regular;
}

/**
 * Kiểm tra xem ngày có trùng với holiday nào trong DB không
 * Bao gồm cả ngày lễ toàn quốc và riêng trường
 */
async function findHoliday(date: Date, schoolId?: Types.ObjectId) {
  const targetDate = dayjs(date);

  // Tìm ngày nghỉ trùng khớp chính xác hoặc ngày lặp lại hằng năm
  return await Holiday.findOne({
    $or: [
      // Lễ cố định (đúng năm)
      { date: targetDate.startOf("day").toDate() },

      // Lễ lặp lại hàng năm (so sánh chỉ tháng/ngày)
      {
        isRecurring: true,
        $expr: {
          $and: [
            { $eq: [{ $month: "$date" }, targetDate.month() + 1] },
            { $eq: [{ $dayOfMonth: "$date" }, targetDate.date()] },
          ],
        },
      },
    ],
    $nor: [
      { type: "national" }, // toàn quốc
      { schoolId: schoolId }, // riêng trường
    ],
  }).lean();
}

/**
 * Kiểm tra xem có buổi học thêm / học bù không
 * (ở bước sau có thể kết nối với bảng ExtraSession)
 */
async function isExtraSession(date: Date, schoolId?: Types.ObjectId) {
  // TODO: sau này có thể tìm trong collection "ExtraSession"
  return false;
}
