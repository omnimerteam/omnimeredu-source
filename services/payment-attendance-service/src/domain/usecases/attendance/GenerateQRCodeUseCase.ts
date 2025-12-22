import { IAttendanceRepository } from "../../repositories/IAttendanceRepository";

export interface QRCodeData {
  attendanceId: string;
  qrData: string;
  expiry: string; // ISO 8601 string
  dynamicCode?: string;
}

export class GenerateQRCodeUseCase {
  constructor(private attendanceRepository: IAttendanceRepository) {}

  async execute(attendanceId: string): Promise<QRCodeData> {
    // Verify attendance exists
    const attendance = await this.attendanceRepository.findById(attendanceId);
    if (!attendance) {
      throw new Error("Attendance not found");
    }

    // Generate dynamic code (6 digits)
    const dynamicCode = Math.floor(100000 + Math.random() * 900000).toString();

    // Create QR data payload
    const payload = {
      attendanceId: attendance.id,
      timestamp: new Date().toISOString(),
      dynamicCode: dynamicCode,
    };

    // Encrypt QR data (simple base64 encoding, can be enhanced with proper encryption)
    const qrData = Buffer.from(JSON.stringify(payload)).toString("base64");

    // Set expiry time (3 minutes from now)
    // Có thể thay đổi số phút ở đây (ví dụ: 2, 3, 5, 10 phút)
    const QR_EXPIRY_MINUTES = 3;
    const expiry = new Date();
    expiry.setMinutes(expiry.getMinutes() + QR_EXPIRY_MINUTES);

    return {
      attendanceId: attendance.id,
      qrData: qrData,
      expiry: expiry.toISOString(),
      dynamicCode: dynamicCode,
    };
  }
}

