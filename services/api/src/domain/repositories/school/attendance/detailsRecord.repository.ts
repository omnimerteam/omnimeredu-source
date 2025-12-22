import { Model, Document } from "mongoose";
import { BaseRepository } from "../../base.repository";
import { IDetailsRecord } from "../../../models";

class DetailsRecordRepository extends BaseRepository<IDetailsRecord> {
  constructor(DetailsRecordModel: Model<IDetailsRecord>) {
    super(DetailsRecordModel);
  }

  async findByAttendanceId(attendanceId: string): Promise<IDetailsRecord[]> {
    return await this.model
      .find({ attendanceId })
      .populate({
        path: "studentId",
        select: "fullName gender phone guardianName guardianPhone", // chỉ lấy các field cần thiết
      })
      .exec();
  }

  /**
   * Find a student's detail record for a specific attendance session
   */
  async findByStudentAndAttendance(
    studentId: string,
    attendanceId: string
  ): Promise<IDetailsRecord | null> {
    return await this.model.findOne({ studentId, attendanceId }).exec();
  }

  /**
   * Update detail record with attendance proof (for QR scan)
   */
  async updateWithProof(
    recordId: string,
    status: string,
    attendanceProof: any,
    note?: string
  ): Promise<IDetailsRecord | null> {
    return await this.model
      .findByIdAndUpdate(
        recordId,
        {
          status,
          attendanceProof,
          ...(note && { note }),
          updatedAt: new Date(),
        },
        { new: true }
      )
      .exec();
  }

  async updateStatusDetailRecord(
    recordId: string,
    status: string,
    note?: string
  ): Promise<IDetailsRecord | null> {
    return await this.model
      .findByIdAndUpdate(
        recordId,
        { status, note, updatedAt: new Date() },
        { new: true }
      )
      .exec();
  }
}
export default DetailsRecordRepository;
