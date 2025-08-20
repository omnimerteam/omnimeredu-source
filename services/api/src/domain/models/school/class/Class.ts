import mongoose, { Schema, Document, Types } from "mongoose";

export interface IClass extends Document {
  _id: Types.ObjectId;
  name: string;
  code: string;
  schoolId: Types.ObjectId;
  students: Types.ObjectId[];
  baseFee: number;
}

const ClassSchema = new Schema<IClass>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    name: { type: String, required: true },
    code: { type: String, required: true, unique: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    students: [{ type: Schema.Types.ObjectId, ref: "User" }],
    baseFee: { type: Number, required: true },
  },
  { timestamps: true }
);

export default mongoose.model<IClass>("Class", ClassSchema);
