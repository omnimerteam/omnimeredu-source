import { SuperAdminSchema } from "../schemas/SuperAdmin.schema";

export const CreateSuperAdminSchema = SuperAdminSchema.omit({ _id: true });
export const UpdateSuperAdminSchema = SuperAdminSchema.partial({
  fullName: true,
  roleId: true,
  gender: true,
  birthday: true,
  phone: true,
  address: true,
  isVerified: true,
});
