import { BaseRepository } from './base.repository';
import { IAttendance } from '../models/Attendance';
import { Model } from 'mongoose';

class AttendenceRepository extends BaseRepository<IAttendance> {
    constructor(AttendenceModel: Model<IAttendance>) {
        super(AttendenceModel);
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

export default AttendenceRepository;

