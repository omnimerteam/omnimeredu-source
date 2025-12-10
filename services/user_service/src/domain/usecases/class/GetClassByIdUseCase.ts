import { IClassRepository } from "../../repositories/IClassRepository";
import { Class } from "../../entities/Class";

export class GetClassByIdUseCase {
  constructor(private classRepository: IClassRepository) {}

  async execute(id: string): Promise<Class | null> {
    return await this.classRepository.findById(id);
  }
}
