import mongoose, { Schema, Document, Types } from 'mongoose';

export interface INews extends Document {
  title: string;
  content: string;
  imageUrl?: string;
  schoolId?: Types.ObjectId;
  publishedAt: Date;
  isPublic: boolean;
  tags?: string[];
}

const NewsSchema = new Schema<INews>({
  title: { type: String, required: true },
  content: { type: String, required: true },
  imageUrl: String,
  schoolId: { type: Schema.Types.ObjectId, ref: 'School' },
  publishedAt: { type: Date, default: Date.now },
  isPublic: { type: Boolean, default: true },
  tags: [String]
}, { timestamps: true });

export default mongoose.model<INews>('News', NewsSchema);
