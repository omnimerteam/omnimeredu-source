import { IHolidayRepository } from "../../repositories/IHolidayRepository";

export class CheckIsHolidayUseCase {
    constructor(private holidayRepository: IHolidayRepository) { }

    async execute(date: Date, schoolId?: string): Promise<boolean> {
        const holidays = await this.holidayRepository.findByDate(date, schoolId);
        return holidays.length > 0;
    }
}
