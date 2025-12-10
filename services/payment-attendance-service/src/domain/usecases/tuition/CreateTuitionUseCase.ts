import { ITuitionRepository } from "../../repositories/ITuitionRepository";
import { CreateTuitionDto } from "../../../presentation/dtos/TuitionDto";
import { Tuition } from "../../entities/Tuition";

export class CreateTuitionUseCase {
  constructor(private tuitionRepository: ITuitionRepository) {}

  async execute(dto: CreateTuitionDto): Promise<Tuition> {
    // Check if tuition already exists for this student and period
    const existing = await this.tuitionRepository.findByStudentAndPeriod(
      dto.studentId,
      dto.periodStart
    );

    if (existing) {
      throw new Error("Tuition already exists for this student and period");
    }

    // Calculate total amount
    let totalAmount = dto.baseFeeSnapshot;

    // Add extra fees
    if (dto.extraFeeDetails) {
      const extraTotal = dto.extraFeeDetails.reduce(
        (sum, fee) => sum + fee.calculatedAmount,
        0
      );
      totalAmount += extraTotal;
    }

    // Subtract discounts
    if (dto.discountDetails) {
      const discountTotal = dto.discountDetails.reduce(
        (sum, discount) => sum + discount.appliedAmount,
        0
      );
      totalAmount -= discountTotal;
    }

    const tuition = new Tuition(
      "", // ID will be generated
      dto.studentId,
      dto.schoolId,
      dto.classId,
      dto.baseFeeSnapshot,
      totalAmount,
      dto.attendedDays || 0,
      "Draft",
      "VND",
      dto.periodStart,
      dto.periodEnd,
      dto.month,
      dto.extraFeeDetails,
      dto.discountDetails,
      [],
      {},
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      dto.dueDate
    );

    return await this.tuitionRepository.create(tuition);
  }
}
