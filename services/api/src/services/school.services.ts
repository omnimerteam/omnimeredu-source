import SchoolRepository from '../repositories/school.repository';
import { ISchool } from '../models/School';
class SchoolService {
    private readonly schoolRepository: SchoolRepository;

    constructor(SchoolRepository: SchoolRepository) {
        this.schoolRepository = SchoolRepository;
    }
    async getAllSchools() {
        return this.schoolRepository.findAll();
    }

    async getSchoolById(id: string) {
        return this.schoolRepository.findById(id);
    }
    //hàm này sẽ tìm kiếm theo tên hoặc mã trường học, nếu cả hai đều không có thì sẽ báo lỗi
    async getSchoolByNameOrCode(name: string, code: string) {
        if (!name && !code) {
            throw new Error('Either name or code must be provided');
        }
        return this.schoolRepository.findByNameOrCode(name, code);
    }

    async createSchool(SchoolData: Partial<ISchool>) {
        return this.schoolRepository.create(SchoolData);
    }

    async updateSchool(id: string, SchoolData: Partial<ISchool>) {
        return this.schoolRepository.update(id, SchoolData);
    }

    async deleteSchool(id: string) {
        return this.schoolRepository.delete(id);
    }
}
//ở đây chỉ export ra 1 class duy nhất, không cần phải export từng hàm
export default SchoolService;