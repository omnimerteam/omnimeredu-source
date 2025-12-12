import { IClassRepository } from "../../repositories/IClassRepository";

export class DeleteClassUseCase {
  constructor(private classRepository: IClassRepository) {}

  async execute(id: string): Promise<boolean> {
    const classEntity = await this.classRepository.findById(id);
    if (!classEntity) {
      throw new Error("Class not found");
    }

    return await this.classRepository.delete(id);
  }
}
