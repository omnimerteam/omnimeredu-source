
import { Model } from 'mongoose';
import { ISchoolAdmin } from '../models/SchoolAdmin';
import { BaseRepository } from './base.repository';

class SchoolAdminRepository extends BaseRepository<ISchoolAdmin> {
    constructor(SchoolAdminModel: Model<ISchoolAdmin>) {
        super(SchoolAdminModel);
    }

    async compareSchoolId(adminId: string, teacherSchoolId: string): Promise<boolean> {
        const admin = await this.model.findById(adminId).select('schoolId');

        if (!admin || !admin.schoolId) {
            throw new Error("Không tìm thấy SchoolAdmin hoặc thiếu schoolId");
        }

        return admin.schoolId.toString() === teacherSchoolId;
    }
}

export default SchoolAdminRepository;