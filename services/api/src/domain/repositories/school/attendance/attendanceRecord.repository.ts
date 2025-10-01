import { Model } from "mongoose";
import { BaseRepository } from "../../base.repository";
import { IAttendanceRecordView } from "../../../models";

class AttendanceRecordViewRepository extends BaseRepository<IAttendanceRecordView> {
  constructor(attendanceRecordViewModel: Model<IAttendanceRecordView>) {
    super(attendanceRecordViewModel);
  }
}

export default AttendanceRecordViewRepository;
