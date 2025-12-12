import { ITuitionRepository } from "../../repositories/ITuitionRepository";
import { Tuition } from "../../entities/Tuition";

export class GetTuitionByIdUseCase {
    constructor(private tuitionRepository: ITuitionRepository) { }

    async execute(id: string): Promise<Tuition | null> {
        return await this.tuitionRepository.findById(id);
    }
}
