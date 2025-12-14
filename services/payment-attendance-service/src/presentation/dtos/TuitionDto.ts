import { ExtraFeeDetail, DiscountDetail } from "../../domain/entities/Tuition";

export class CreateTuitionDto {
  studentId!: string;
  schoolId!: string;
  classId!: string;
  periodStart!: Date;
  periodEnd!: Date;
  baseFeeSnapshot!: number;
  attendedDays?: number;
  extraFeeDetails?: ExtraFeeDetail[];
  discountDetails?: DiscountDetail[];
  month?: string;
  dueDate?: Date;
}

export class UpdateTuitionDto {
  baseFeeSnapshot?: number;
  totalAmount?: number;
  attendedDays?: number;
  status?: "Draft" | "Pending" | "Paid" | "Cancelled" | "Failed";
  extraFeeDetails?: ExtraFeeDetail[];
  discountDetails?: DiscountDetail[];
  paidAt?: Date;
  dueDate?: Date;
}

export class ConfirmTuitionDto {
  confirmedBy!: string;
}
