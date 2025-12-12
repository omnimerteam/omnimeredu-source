import { IClassRepository } from "../../repositories/IClassRepository";
import { Class } from "../../entities/Class";
import { UpdateClassDto } from "../../../presentation/dtos/UpdateClassDto";

export class UpdateClassUseCase {
  constructor(private classRepository: IClassRepository) {}

  async execute(id: string, dto: UpdateClassDto): Promise<Class> {
    const existingClass = await this.classRepository.findById(id);
    if (!existingClass) {
      throw new Error("Class not found");
    }

    // Update only provided fields
    const updatedClass = new Class(
      existingClass.id,
      dto.name ?? existingClass.name,
      existingClass.code, // code cannot be updated
      existingClass.schoolId,
      existingClass.gradeId,
      dto.maxStudents ?? existingClass.maxStudents,
      dto.baseFee ?? existingClass.baseFee
    );

    return await this.classRepository.update(updatedClass);
  }
}
