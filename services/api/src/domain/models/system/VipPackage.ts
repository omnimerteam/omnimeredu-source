import mongoose, { Schema, Document, Types } from "mongoose";

export interface IVipPackage extends Document {
  _id: Types.ObjectId;
  name: "Basic" | "Pro" | "Enterprise";
  price: number;

  // Giới hạn dữ liệu
  maxStudents: number; // số học sinh tối đa
  maxStorageMB: number; // dung lượng lưu trữ tối đa (MB)

  // Các chức năng mở khóa
  permissions: {
    canExportReports: boolean; // có thể xuất báo cáo PDF/Excel
    canUseDiscounts: boolean; // có thể dùng ưu đãi/học phí động
    canMultiSchool: boolean; // có thể quản lý nhiều trường
  };

  // Liệt kê tính năng mô tả
  features: string[];
}

const VipPackageSchema = new Schema<IVipPackage>({
  _id: { type: Schema.Types.ObjectId, auto: true },
  name: {
    type: String,
    enum: ["Basic", "Pro", "Enterprise"],
    unique: true,
    required: true,
  },
  price: { type: Number, required: true },

  // Giới hạn dữ liệu
  maxStudents: { type: Number, required: true },
  maxStorageMB: { type: Number, required: true },

  // Các quyền tính năng
  permissions: {
    canExportReports: { type: Boolean, default: false },
    canUseDiscounts: { type: Boolean, default: false },
    canMultiSchool: { type: Boolean, default: false },
  },

  features: [String],
});

export default mongoose.model<IVipPackage>("VipPackage", VipPackageSchema);
