import { GradeRepositoryImpl } from "../../../data/repositories/GradeRepositoryImpl";
import { Grade } from "../../entities/Grade";
import { EducationSystemLevelsEnum, EducationGradesEnum } from "shared-lib";

export interface BulkCreateGradeDto {
  schoolId: string;
  name: string;
  level: EducationSystemLevelsEnum;
  gradeGroup?: EducationGradesEnum;
  order?: number;
  active?: boolean;
  ageRange?: any;
  description?: string;
  customFields?: any;
}

export interface BulkUpdateGradeDto {
  id: string;
  updates: Partial<{
    name: string;
    level: EducationSystemLevelsEnum;
    gradeGroup: EducationGradesEnum;
    order: number;
    active: boolean;
    ageRange: any;
    description: string;
    customFields: any;
  }>;
}

export interface BulkOperationResult<T> {
  successful: T[];
  failed: {
    item: T;
    error: string;
  }[];
  totalProcessed: number;
  totalSuccessful: number;
  totalFailed: number;
}

export class BulkGradeOperationsUseCase {
  constructor(private gradeRepository: GradeRepositoryImpl) {}

  async bulkCreate(
    grades: BulkCreateGradeDto[]
  ): Promise<BulkOperationResult<Grade>> {
    const results: BulkOperationResult<Grade> = {
      successful: [],
      failed: [],
      totalProcessed: grades.length,
      totalSuccessful: 0,
      totalFailed: 0,
    };

    for (const gradeData of grades) {
      try {
        const grade = new Grade(
          "", // Will be generated
          gradeData.schoolId,
          gradeData.name,
          gradeData.level,
          gradeData.gradeGroup || EducationGradesEnum.None, // Default or handle optionality properly if needed
          gradeData.order || 0,
          gradeData.active ?? true,
          gradeData.ageRange,
          gradeData.description,
          gradeData.customFields,
          new Date(),
          new Date()
        );

        const createdGrade = await this.gradeRepository.create(grade);
        results.successful.push(createdGrade);
        results.totalSuccessful++;
      } catch (error: any) {
        results.failed.push({
          item: gradeData as any,
          error: error.message,
        });
        results.totalFailed++;
      }
    }

    return results;
  }

  async bulkUpdate(
    updatesList: BulkUpdateGradeDto[]
  ): Promise<BulkOperationResult<Grade>> {
    const results: BulkOperationResult<Grade> = {
      successful: [],
      failed: [],
      totalProcessed: updatesList.length,
      totalSuccessful: 0,
      totalFailed: 0,
    };

    for (const { id, updates } of updatesList) {
      try {
        // Check if grade exists
        const existingGrade = await this.gradeRepository.findById(id);
        if (!existingGrade) {
          results.failed.push({
            item: { id, updates } as any,
            error: "Grade not found",
          });
          results.totalFailed++;
          continue;
        }

        // Update grade with new values
        Object.assign(existingGrade, updates);

        const updatedGrade = await this.gradeRepository.update(existingGrade);
        results.successful.push(updatedGrade);
        results.totalSuccessful++;
      } catch (error: any) {
        results.failed.push({
          item: { id, updates } as any,
          error: error.message,
        });
        results.totalFailed++;
      }
    }

    return results;
  }

  async bulkDelete(ids: string[]): Promise<BulkOperationResult<string>> {
    const results: BulkOperationResult<string> = {
      successful: [],
      failed: [],
      totalProcessed: ids.length,
      totalSuccessful: 0,
      totalFailed: 0,
    };

    for (const id of ids) {
      try {
        const success = await this.gradeRepository.delete(id);
        if (success) {
          results.successful.push(id);
          results.totalSuccessful++;
        } else {
          results.failed.push({
            item: id,
            error: "Grade not found",
          });
          results.totalFailed++;
        }
      } catch (error: any) {
        results.failed.push({
          item: id,
          error: error.message,
        });
        results.totalFailed++;
      }
    }

    return results;
  }

  async bulkActivate(ids: string[]): Promise<BulkOperationResult<Grade>> {
    const updates = ids.map((id) => ({
      id,
      updates: { active: true },
    }));

    return this.bulkUpdate(updates);
  }

  async bulkDeactivate(ids: string[]): Promise<BulkOperationResult<Grade>> {
    const updates = ids.map((id) => ({
      id,
      updates: { active: false },
    }));

    return this.bulkUpdate(updates);
  }
}
