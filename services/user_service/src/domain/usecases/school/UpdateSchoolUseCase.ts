import { ISchoolRepository } from "../../repositories/ISchoolRepository";
import { School } from "../../entities/School";
import { UpdateSchoolDto } from "../../../presentation/dtos/UpdateSchoolDto";

export class UpdateSchoolUseCase {
  constructor(private schoolRepository: ISchoolRepository) {}

  async execute(id: string, dto: UpdateSchoolDto): Promise<School> {
    const existingSchool = await this.schoolRepository.findById(id);
    if (!existingSchool) {
      throw new Error("School not found");
    }

    // Update only provided fields
    const updatedSchool = new School(
      existingSchool.id,
      dto.name ?? existingSchool.name,
      existingSchool.code, // code cannot be updated
      dto.address ?? existingSchool.address,
      existingSchool.level, // level cannot be updated
      existingSchool.adminId,
      dto.phone ?? existingSchool.phone,
      dto.description ?? existingSchool.description,
      dto.logoUrl ?? existingSchool.logoUrl,
      existingSchool.studentCount,
      dto.customTheme ?? existingSchool.customTheme
    );

    return await this.schoolRepository.update(updatedSchool);
  }
}
