import { BaseRepository } from "./base.repository";
import { IAttendance } from "../models/Attendance";
import { Model } from "mongoose";

class AttendanceRepository extends BaseRepository<IAttendance> {
  constructor(AttendanceModel: Model<IAttendance>) {
    super(AttendanceModel);
  }
  async findBySchoolId(schoolId: string) {
    return this.model.find({ schoolId: schoolId }).exec();
  }

  async findByClassId(classId: string) {
    return this.model.find({ classId }).exec();
  }

  async findByUserId(userId: string) {
    return this.model.find({ userId: userId }).exec();
  }
}

export default AttendanceRepository;
