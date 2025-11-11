// services/attendance/attendance.excel-builder.ts
import ExcelJS from "exceljs";
import { translateGender, translateStatus } from "../../../utils/ExcelUtils";
import { GenderEnum } from "../../../../common/enum/gender.enum";
import { AttendanceStatusEnum } from "../../../../common/enum/attendanceStatus.enum";
import { IAttendanceRecordView, IStudentAttendance } from "../../../models";

/**
 * Class chuyên dựng file Excel điểm danh — tách biệt khỏi Service
 */
export class AttendanceExcelBuilder {
  private workbook: ExcelJS.Workbook;
  private sheet: ExcelJS.Worksheet;

  constructor() {
    this.workbook = new ExcelJS.Workbook();
    this.sheet = this.workbook.addWorksheet("Bảng điểm danh");
  }

  /**
   * Tạo toàn bộ file Excel từ dữ liệu điểm danh
   */
  async build(data: IAttendanceRecordView): Promise<Buffer> {
    this.addHeader();
    this.addMeta(data);
    this.addTable(data.students ?? []);
    this.applySheetStyles();
    const arrayBuffer = await this.workbook.xlsx.writeBuffer();
    return Buffer.from(arrayBuffer);
  }

  /** Header chính */
  private addHeader() {
    this.sheet.mergeCells("A1", "F1");
    const title = this.sheet.getCell("A1");
    title.value = "BẢNG ĐIỂM DANH";
    title.font = { size: 16, bold: true, color: { argb: "FF1A73E8" } };
    title.alignment = { horizontal: "center", vertical: "middle" };
    this.sheet.getRow(1).height = 28;
  }

  /** Thông tin chung: Ngày / Trường / Lớp */
  private addMeta(data: IAttendanceRecordView) {
    const formattedDate = new Date(data.date).toLocaleDateString("vi-VN");
    this.sheet.addRow([]);
    this.sheet.addRow([`Ngày: ${formattedDate}`]);
    this.sheet.addRow([`Trường: ${data.school?.name ?? ""}`]);
    this.sheet.addRow([`Lớp: ${data.class?.name ?? ""}`]);
    this.sheet.addRow([]);
  }

  /** Tạo bảng dữ liệu học sinh */
  private addTable(students: IStudentAttendance[]) {
    const headerRow = this.sheet.addRow([
      "STT",
      "Họ tên học sinh",
      "Ngày sinh",
      "Giới tính",
      "Trạng thái",
      "Ghi chú",
    ]);

    // Header style
    headerRow.font = { bold: true, color: { argb: "FFFFFFFF" } };
    headerRow.fill = {
      type: "pattern",
      pattern: "solid",
      fgColor: { argb: "FF4A90E2" },
    };
    headerRow.alignment = { horizontal: "center", vertical: "middle" };

    headerRow.eachCell((cell) => {
      cell.border = this.cellBorder();
    });

    // Body rows
    students.forEach((student, index) => {
      const row = this.sheet.addRow([
        index + 1,
        student.name,
        student.birthday
          ? new Date(student.birthday).toLocaleDateString("vi-VN")
          : "",
        translateGender(student.gender),
        translateStatus(student.status),
        "",
      ]);

      row.eachCell((cell) => {
        cell.border = this.cellBorder();
        cell.alignment = { vertical: "middle", horizontal: "center" };
      });
    });
  }

  /** Định dạng toàn cục */
  private applySheetStyles() {
    this.sheet.columns = [
      { width: 6 },
      { width: 25 },
      { width: 15 },
      { width: 10 },
      { width: 18 },
      { width: 25 },
    ];
    this.sheet.views = [{ state: "frozen", ySplit: 7 }];
  }

  /** Border chuẩn cho cell */
  private cellBorder() {
    return {
      top: { style: "thin" },
      left: { style: "thin" },
      bottom: { style: "thin" },
      right: { style: "thin" },
    } as ExcelJS.Borders;
  }
}
