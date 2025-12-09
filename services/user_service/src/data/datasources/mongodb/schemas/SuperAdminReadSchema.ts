import mongoose, { Schema } from "mongoose";
import { UserReadModel } from "./UserReadSchema";

const SuperAdminReadSchema = new Schema({});

export const SuperAdminReadModel = UserReadModel.discriminator(
  "SuperAdmin",
  SuperAdminReadSchema
);
