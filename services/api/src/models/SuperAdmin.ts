import { Schema } from "mongoose";
import { BaseUser, IBaseUser } from "./BaseUser";
export interface ISuperAdmin extends IBaseUser {}

export const SuperAdmin = BaseUser.discriminator<ISuperAdmin>(
  "SuperAdmin",
  new Schema<ISuperAdmin>({})
);
