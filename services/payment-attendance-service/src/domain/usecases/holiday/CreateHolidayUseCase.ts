import { IHolidayRepository } from "../../repositories/IHolidayRepository";
import { CreateHolidayDto } from "../../../presentation/dtos/HolidayDto";
import { Holiday } from "../../entities/Holiday";

export class CreateHolidayUseCase {
  constructor(private holidayRepository: IHolidayRepository) {}

  async execute(dto: CreateHolidayDto): Promise<Holiday> {
    // Validate school holiday must have schoolId
    if (dto.type === "school" && !dto.schoolId) {
      throw new Error("School holidays must have a schoolId");
    }

    const holiday = new Holiday(
      "", // ID will be generated
      dto.name,
      dto.date,
      dto.isRecurring || false,
      dto.type,
      dto.schoolId
    );

    return await this.holidayRepository.create(holiday);
  }
}
