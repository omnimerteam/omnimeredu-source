import { Schema } from "mongoose";
import { mongooseInstance as mongoose } from "shared-lib";
import { UserReadModel } from "./UserReadSchema";

const SuperAdminReadSchema = new Schema({});

export const SuperAdminReadModel = UserReadModel.discriminator(
  "SuperAdmin",
  SuperAdminReadSchema
);
