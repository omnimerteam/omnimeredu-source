import { z } from "zod";
import { VipInvoiceSchema } from "../schemas/VipInvoice.schema";

export const createVipInvoiceBodySchema = VipInvoiceSchema.omit({ _id: true });

export const updateVipInvoiceBodySchema = VipInvoiceSchema.partial({
  schoolId: true,
  packageId: true,
  subscriptionId: true,
  paymentMethodId: true,
  amount: true,
  transactionId: true,
  status: true,
  paidAt: true,
});
