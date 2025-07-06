import mongoose, { Schema, Document, Types } from 'mongoose';

export interface ISchool extends Document {
  name: string;
  code: string;
  address: string;
  phone?: string;
  description?: string;
  level: 'Preschool' | 'Primary' | 'Secondary' | 'HighSchool' | 'University';
  adminId?: Types.ObjectId;
  logoUrl?: string;
  customTheme?: object;
}

const SchoolSchema = new Schema<ISchool>({
  name: { type: String, required: true },
  code: { type: String, required: true, unique: true },
  address: { type: String, required: true },
  phone: String,
  description: String,
  level: { type: String, enum: ['Preschool', 'Primary', 'Secondary', 'HighSchool', 'University'], required: true },
  adminId: { type: Schema.Types.ObjectId, ref: 'User' },
  logoUrl: String,
  customTheme: Object
}, { timestamps: true });

export default mongoose.model<ISchool>('School', SchoolSchema);