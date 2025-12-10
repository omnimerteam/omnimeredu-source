export class CreateHolidayDto {
  name!: string;
  date!: Date;
  isRecurring?: boolean;
  type!: "national" | "school";
  schoolId?: string;
}

export class UpdateHolidayDto {
  name?: string;
  date?: Date;
  isRecurring?: boolean;
}
