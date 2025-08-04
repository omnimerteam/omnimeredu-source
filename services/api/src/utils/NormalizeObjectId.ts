import mongoose from "mongoose";

/// Hàm này dùng để chuẩn hóa ObjectId từ các định dạng khác nhau về dạng chuỗi
export function NormalizeObjectId(id: any): string | undefined {
    if (!id) return undefined;
    if (typeof id === "string") return id;
    if (id instanceof mongoose.Types.ObjectId) return id.toString();
    return id._id?.toString();
}
