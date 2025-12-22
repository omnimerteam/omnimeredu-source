import { Holiday } from "../entities/Holiday";

export interface IHolidayRepository {
  create(holiday: Holiday): Promise<Holiday>;
  findById(id: string): Promise<Holiday | null>;
  findByDate(date: Date, schoolId?: string): Promise<Holiday[]>;
  findByDateRange(
    startDate: Date,
    endDate: Date,
    schoolId?: string
  ): Promise<Holiday[]>;
  findByType(
    type: "national" | "school",
    schoolId?: string
  ): Promise<Holiday[]>;
  update(holiday: Holiday): Promise<Holiday>;
  delete(id: string): Promise<boolean>;
}
