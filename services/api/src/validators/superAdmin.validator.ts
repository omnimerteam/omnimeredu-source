import { SuperAdminSchema } from "../schemas/SuperAdmin.schema";

export const createSuperAdminSchema = SuperAdminSchema.omit({ _id: true });
export const updateSuperAdminSchema = SuperAdminSchema.partial({
  fullName: true,
  roleId: true,
  gender: true,
  birthday: true,
  phone: true,
  address: true,
  isVerified: true,
});
