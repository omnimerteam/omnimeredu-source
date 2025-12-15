import { Schema } from "mongoose";
import { mongooseInstance as mongoose } from "shared-lib";

const RoleReadSchema = new Schema(
  {
    _id: { type: String },
    name: { type: String, required: true },
    group: { type: String, required: true },
    description: String,
    permissions: [String],
  },
  {
    timestamps: true,
    _id: false,
  }
);

export const RoleReadModel = mongoose.model("roles", RoleReadSchema);
