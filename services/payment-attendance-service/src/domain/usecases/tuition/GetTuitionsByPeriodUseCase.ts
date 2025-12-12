import { ITuitionRepository } from "../../repositories/ITuitionRepository";
import { Tuition } from "../../entities/Tuition";

export class GetTuitionsByPeriodUseCase {
    constructor(private tuitionRepository: ITuitionRepository) { }

    async execute(schoolId: string, periodStart: Date, periodEnd: Date): Promise<Tuition[]> {
        return await this.tuitionRepository.findBySchoolAndPeriod(schoolId, periodStart, periodEnd);
    }
}
