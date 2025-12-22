import { IClassReadRepository } from "../../repositories/IClassReadRepository";

export class GetStudentsByClassIdUseCase {
  constructor(private classReadRepository: IClassReadRepository) {}

  async execute(classId: string): Promise<any[]> {
    return await this.classReadRepository.findStudentsByClassId(classId);
  }
}
