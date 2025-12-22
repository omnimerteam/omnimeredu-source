import { IHolidayRepository } from "../../repositories/IHolidayRepository";
import { Holiday } from "../../entities/Holiday";

export class GetHolidaysByDateRangeUseCase {
    constructor(private holidayRepository: IHolidayRepository) { }

    async execute(startDate: Date, endDate: Date, schoolId?: string): Promise<Holiday[]> {
        return await this.holidayRepository.findByDateRange(startDate, endDate, schoolId);
    }
}
