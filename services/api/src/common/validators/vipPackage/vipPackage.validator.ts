import { VipPackageSchema } from "./VipPackage.schema";

export const createVipPackageBodySchema = VipPackageSchema.omit({ _id: true });

export const updateVipPackageBodySchema = VipPackageSchema.partial({
  name: true,
  price: true,
  maxStudents: true,
  maxInvoices: true,
  features: true,
});
