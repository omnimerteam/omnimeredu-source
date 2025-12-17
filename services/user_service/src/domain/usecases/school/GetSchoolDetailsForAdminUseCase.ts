import { SchoolRepositoryImpl } from "../../../data/repositories/SchoolRepositoryImpl";
import { School } from "../../entities/School";

export class GetSchoolDetailsForAdminUseCase {
  constructor(private schoolRepository: SchoolRepositoryImpl) {}

  async execute(userId: string): Promise<School | null> {
    // First, get the SchoolAdmin record for this user
    const schoolAdmin = await this.schoolRepository.findSchoolAdminByUserId(userId);
    if (!schoolAdmin) {
      return null;
    }

    // Then get the school details
    return await this.schoolRepository.findById(schoolAdmin.schoolId);
  }
}