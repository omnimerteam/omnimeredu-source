import { VipPackageSchema } from "../schemas/VipPackage.schema";

export const createVipPackageBodySchema = VipPackageSchema.omit({ _id: true });

export const updateVipPackageBodySchema = VipPackageSchema.partial({
  name: true,
  price: true,
  maxStudents: true,
  maxInvoices: true,
  features: true,
});
