import { Schema } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";
export interface ISuperAdmin extends IBaseUser {}

const SuperAdmin = BaseUser.discriminator<ISuperAdmin>(
  "SuperAdmin",
  new Schema<ISuperAdmin>({})
);

export default SuperAdmin;
