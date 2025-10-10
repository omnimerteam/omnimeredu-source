import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IRole extends Document {
  _id: Types.ObjectId;
  name: 'SuperAdmin' | 'SchoolAdmin' | 'Teacher' | 'Student' | 'CanteenStaff' | 'Nurse' | 'Security';
  description?: string;
  permissions?: string[];
}


const RoleSchema = new Schema<IRole>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    name: {
      type: String,
      enum: [
        "SuperAdmin",
        "SchoolAdmin",
        "Teacher",
        "Student",
        "CanteenStaff",
        "Nurse",
        "Security",
      ],
      required: true,
      unique: true,
      index: true, //thêm index
    },
    description: { type: String },
    permissions: [{ type: String }],
  },
  { timestamps: true }
);

export default mongoose.model<IRole>("Role", RoleSchema);

