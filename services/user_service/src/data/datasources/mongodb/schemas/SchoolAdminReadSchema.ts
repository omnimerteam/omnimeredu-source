import { Schema } from "mongoose";
import { mongooseInstance as mongoose } from "shared-lib";
import { UserReadModel } from "./UserReadSchema";

const SchoolAdminReadSchema = new Schema({
  position: { type: String },
});

// Using discriminator for inheritance in Mongo Read Models as well
export const SchoolAdminReadModel = UserReadModel.discriminator(
  "SchoolAdmin",
  SchoolAdminReadSchema
);
