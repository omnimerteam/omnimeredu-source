import { TuitionSchema } from "../schemas/Tuition.schema";

export const createTuitionBodySchema = TuitionSchema.omit({ _id: true });

export const updateTuitionBodySchema = TuitionSchema.partial({
  studentId: true,
  month: true,
  extraFeeIds: true,
  discountId: true,
  totalAmount: true,
  attendedDays: true,
  status: true,
});
