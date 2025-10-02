// role.model.ts
import mongoose, { Schema, Document, Types } from "mongoose";
import {
  RoleEnum,
  RoleGroup,
  RoleGroupTuple,
  RoleTuple,
} from "../../../common/enum/role.enum";

export interface IRole extends Document {
  _id: Types.ObjectId;
  name: RoleEnum;
  description?: string;
  group: RoleGroup;
  permissions?: string[];
}

const RoleSchema = new Schema<IRole>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    name: {
      type: String,
      enum: RoleTuple,
      required: true,
      index: true,
    },

    group: {
      type: String,
      enum: RoleGroupTuple,
      required: true,
      index: true,
    },

    description: { type: String },
    permissions: [{ type: String }],
  },
  { timestamps: true }
);

export default mongoose.model<IRole>("Role", RoleSchema);
