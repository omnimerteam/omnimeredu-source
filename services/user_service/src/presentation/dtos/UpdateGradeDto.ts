export class UpdateGradeDto {
  name?: string;
  order?: number;
  active?: boolean;
  ageRange?: { min?: number; max?: number };
  description?: string;
  customFields?: object;
}
