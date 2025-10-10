import mongoose, { Schema, Document, Types } from "mongoose";

export interface INews extends Document {
  _id: Types.ObjectId;
  title: string;
  quillDelta?: any; // có thể null nếu có ảnh
  imagePath?: string; // đường dẫn trong Firebase Storage bucket
  imageUrl?: string; // link public / signed URL (optional)
  schoolId?: Types.ObjectId;
  publishedAt: Date;
  isPublic: boolean;
  tags?: string[];
}

const NewsSchema = new Schema<INews>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    title: { type: String, required: true },

    quillDelta: { type: Object },

    imagePath: {
      type: String,
      validate: {
        validator: function (this: INews, v: string | undefined) {
          // Nếu có imageUrl thì imagePath cũng phải có
          if (this.imageUrl && !v) return false;
          return true;
        },
        message: "imagePath là bắt buộc nếu có imageUrl",
      },
    },

    imageUrl: { type: String },

    schoolId: { type: Schema.Types.ObjectId, ref: "School" },
    publishedAt: { type: Date, default: Date.now },
    // Công khai cho ngoài trường coi
    isPublic: { type: Boolean, default: true },
    tags: [String],
  },
  { timestamps: true }
);

// Validator tổng để đảm bảo quillDelta hoặc imagePath phải có ít nhất 1
NewsSchema.pre("validate", function (next) {
  if (!this.quillDelta && !this.imagePath) {
    return next(new Error("Phải có ít nhất quillDelta hoặc imagePath"));
  }
  next();
});

export default mongoose.model<INews>("News", NewsSchema);
