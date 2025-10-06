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
