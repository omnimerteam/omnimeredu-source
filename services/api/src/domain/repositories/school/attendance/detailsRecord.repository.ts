import { Model, Document } from "mongoose";
import { BaseRepository } from "../../base.repository";
import { IDetailsRecord } from "../../../models";

class DetailsRecordRepository extends BaseRepository<IDetailsRecord> {
  constructor(DetailsRecordModel: Model<IDetailsRecord>) {
    super(DetailsRecordModel);
  }

  async findByAttendanceId(attendanceId: string): Promise<IDetailsRecord[]> {
    return this.model.find({ attendanceId }).exec();
  }

  async updateStatusDetailRecord(
    recordId: string,
    status: string,
    note?: string
  ): Promise<IDetailsRecord | null> {
    return this.model
      .findByIdAndUpdate(
        recordId,
        { status, note, updatedAt: new Date() },
        { new: true }
      )
      .exec();
  }
}
export default DetailsRecordRepository;
