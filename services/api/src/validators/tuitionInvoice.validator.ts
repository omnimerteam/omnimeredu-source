import { z } from "zod";
import { TuitionInvoiceSchema } from "../schemas/TuitionInvoice.schema";

export const createTuitionInvoiceBodySchema = TuitionInvoiceSchema.omit({
  _id: true,
});

export const updateTuitionInvoiceBodySchema = TuitionInvoiceSchema.partial({
  studentId: true,
  tuitionId: true,
  paymentMethodId: true,
  amount: true,
  transactionId: true,
  status: true,
  paidAt: true,
});
