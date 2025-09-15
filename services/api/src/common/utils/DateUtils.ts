/**
 * DateUtils - Helper để làm việc với Date theo múi giờ local/UTC
 * Mặc định: VN (UTC+7)
 */
export class DateUtils {
  private static readonly VN_TIMEZONE_OFFSET = 7; // giờ

  /**
   * Trả về khoảng thời gian UTC (start, end) ứng với ngày local
   * @param date Ngày local (mặc định: hôm nay)
   * @param tzOffset Múi giờ (default = 7 cho VN)
   */
  static getUtcDayRange(
    date: Date = new Date(),
    tzOffset: number = DateUtils.VN_TIMEZONE_OFFSET
  ) {
    // clone tránh modify object gốc
    const start = new Date(date);
    const end = new Date(date);

    // convert về UTC bằng cách setUTCHours với offset
    start.setUTCHours(0 - tzOffset, 0, 0, 0);
    end.setUTCHours(23 - tzOffset, 59, 59, 999);

    return { start, end };
  }

  /**
   * Chuyển Date UTC trong DB về Date local để hiển thị
   */
  static toLocal(
    date: Date,
    tzOffset: number = DateUtils.VN_TIMEZONE_OFFSET
  ): Date {
    return new Date(date.getTime() + tzOffset * 60 * 60 * 1000);
  }

  /**
   * Chuyển Date local về UTC để lưu DB
   */
  static toUtc(
    date: Date,
    tzOffset: number = DateUtils.VN_TIMEZONE_OFFSET
  ): Date {
    return new Date(date.getTime() - tzOffset * 60 * 60 * 1000);
  }
}
