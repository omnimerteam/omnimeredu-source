import { DefaultLogger } from "../utils/DefaultLogger";
import SchoolAdminRepository from "../repositories/schoolAdmin.repository";
import { ITeachingAssignment } from "../models/TeachingAssignment";
import { ISchoolAdmin } from "../models/SchoolAdmin";
class SchoolAdminService {
    private readonly schoolAdminRepository: SchoolAdminRepository;
    private readonly logger: DefaultLogger;
    constructor(logger: DefaultLogger, schoolAdminRepository: SchoolAdminRepository) {
        this.logger = logger;
        this.schoolAdminRepository = schoolAdminRepository;
    }

    async getAllSchoolAdmins(userId: string, userRole: string) {
        try {
            const schoolAdmins = await this.schoolAdminRepository.findAll();
            await this.logger.log({
                userId,
                action: "GET_ALL_SCHOOL_ADMINS",
                roleSnapshot: userRole,
                metadata: { SchoolAdmins: schoolAdmins.length }
            })
            return schoolAdmins;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "GET_ALL_SCHOOL_ADMINS_FAILED",
                roleSnapshot: userRole,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }

    async getSchoolAdminById(schoolAdminId: string, userId: string, userRole: string) {
        try {
            const schoolAdmin = await this.schoolAdminRepository.findById(schoolAdminId);
            await this.logger.log({
                userId,
                action: "GET_ALL_SCHOOL_ADMIN_BY_ID",
                roleSnapshot: userRole,
                targetId: schoolAdminId,
                metadata: { SchoolAdmins: !!schoolAdmin }
            })
            return schoolAdmin;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "GET_ALL_SCHOOL_ADMIN_BY_ID_FAILED",
                roleSnapshot: userRole,
                targetId: schoolAdminId,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }
    async createSchoolAdmin(SchoolAdminData: Partial<ISchoolAdmin>, userId: string, userRole: string) {
        try {
            const schoolAdmin = await this.schoolAdminRepository.create(SchoolAdminData)
            await this.logger.log({
                userId,
                action: "CREATE_SCHOOL_ADMIN",
                roleSnapshot: userRole,
                metadata: { SchoolAdmins: !!schoolAdmin }
            })
            return schoolAdmin;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "CREATE_SCHOOL_ADMIN_FAILED",
                roleSnapshot: userRole,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }
    async updateSchoolAdmin(schoolAdminId: string, SchoolAdminData: Partial<ISchoolAdmin>, userId: string, userRole: string) {
        try {
            const schoolAdmin = await this.schoolAdminRepository.update(schoolAdminId, SchoolAdminData);
            await this.logger.log({
                userId,
                action: "UPDATE_SCHOOL_ADMIN",
                roleSnapshot: userRole,
                targetId: schoolAdminId,
                metadata: { SchoolAdmins: !!schoolAdmin }
            })
            return schoolAdmin;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "UPDATE_SCHOOL_ADMIN_FAILED",
                roleSnapshot: userRole,
                targetId: schoolAdminId,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }
    async deleteSchoolAdmin(schoolAdminId: string, userId: string, userRole: string) {
        try {
            const schoolAdmin = await this.schoolAdminRepository.delete(schoolAdminId);
            await this.logger.log({
                userId,
                action: "DELETE_SCHOOL_ADMIN",
                roleSnapshot: userRole,
                targetId: schoolAdminId,
                metadata: { SchoolAdmins: !!schoolAdmin }
            })
            return schoolAdmin;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "DELETE_SCHOOL_ADMIN_FAILED",
                roleSnapshot: userRole,
                targetId: schoolAdminId,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }

}
export default SchoolAdminService;