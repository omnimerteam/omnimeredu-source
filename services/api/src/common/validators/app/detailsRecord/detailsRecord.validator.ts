import { DetailsRecordSchema } from "./DetailsRecord.schema";

// Create - tất cả trường bắt buộc trừ _id
export const createDetailsRecordBodySchema = DetailsRecordSchema.omit({
  _id: true,
});

// Update - tất cả trường optional
export const updateDetailsRecordBodySchema = DetailsRecordSchema.partial({
  studentId: true,
  attendanceId: true,
  status: true,
  note: true,
});

export const updateStatusDetailsRecordBodySchema = DetailsRecordSchema.pick({
  status: true,
  note: true,
});
