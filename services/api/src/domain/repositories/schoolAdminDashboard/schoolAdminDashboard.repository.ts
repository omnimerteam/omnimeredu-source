// repositories/schoolAdminDashboard.repository.ts
import { Model } from "mongoose";
import { IBaseUser, IClass, IMembershipRequest, ISchool } from "../../models";

class SchoolAdminDashboardRepository {
  private readonly userModel: Model<IBaseUser>;
  private readonly classModel: Model<IClass>;
  private readonly membershipRequestModel: Model<IMembershipRequest>;

  constructor(
    userModel: Model<IBaseUser>,
    classModel: Model<IClass>,
    membershipRequestModel: Model<IMembershipRequest>
  ) {
    this.userModel = userModel;
    this.classModel = classModel;
    this.membershipRequestModel = membershipRequestModel;
  }

  /**
   * Lấy dữ liệu tổng quan cho SchoolAdmin
   * @param adminId ID của SchoolAdmin (từ req.user.id)
   */
  async getSummary(schoolId: string) {
    // Tổng số học sinh
    const totalStudents = await this.userModel.countDocuments({
      schoolId,
      roleKey: "Student",
    });

    // Tổng số giáo viên
    const totalTeachers = await this.userModel.countDocuments({
      schoolId,
      roleKey: "Teacher",
    });

    const totalStaff = await this.userModel.countDocuments({
      schoolId,
      roleKey: "Staff",
    });

    // Tổng số lớp
    const totalClasses = await this.classModel.countDocuments({ schoolId });

    // Số request gia nhập trường (membership requests pending)
    const membershipRequests = await this.membershipRequestModel.countDocuments(
      {
        schoolId,
        status: "Pending",
      }
    );

    // Trả về data dạng object
    return {
      totalStudents,
      totalTeachers,
      totalStaff,
      totalClasses,
      membershipRequests,
      lastUpdated: new Date(),
    };
  }
}

export default SchoolAdminDashboardRepository;
