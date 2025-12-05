import { NextFunction } from "express";
import mongoose, { Schema, Document } from "mongoose";

// --- Enums ---
export const GenderTuple = ["Male", "Female", "Other"];
export const RoleGroupTuple = [
  "Student",
  "Teacher",
  "SchoolAdmin",
  "SuperAdmin",
  "Staff",
];

// --- Interfaces ---
export interface IUserReadModel extends Document {
  fullName: string;
  roleKey: string;
  email?: string;
  gender?: string;
  birthday?: Date;
  phone?: string;
  address?: string;
  isVerified?: boolean;
  schoolId?: string;
  avatarUrl?: string;
  deletedAt?: Date | null;
}

export interface IStudentReadModel extends IUserReadModel {
  classId?: string;
  educationLevel: string;
  gradeGroup: string;
  guardianName?: string;
  guardianPhone?: string;
  meta?: any;
}

// --- Base Schema ---
const UserReadSchema = new Schema<IUserReadModel>(
  {
    fullName: { type: String, required: true, index: true },
    roleKey: {
      type: String,
      enum: RoleGroupTuple,
      required: true,
      index: true,
    },
    email: { type: String, lowercase: true, trim: true, index: true }, // Contact email
    gender: { type: String, enum: GenderTuple, default: "Male" },
    birthday: Date,
    phone: { type: String, index: true },
    address: String,
    isVerified: { type: Boolean, default: false },
    schoolId: { type: String, index: true }, // Storing ID as string for Read Model simplicity
    avatarUrl: String,
    deletedAt: { type: Date, default: null, index: true }, // Soft Delete
  },
  {
    discriminatorKey: "roleKey",
    collection: "users_read", // Separate collection for Read Model? Or same 'users' if syncing?
    // Plan says "Query Side... MongoDB". If we are syncing from SQL, this is a separate Read DB.
    // So 'users_read' or just 'users' in the Mongo DB is fine.
    timestamps: true,
  }
);

// Middleware to filter soft-deleted users (Optional, but good for Read side)
UserReadSchema.pre(/^find/, function (this: any, next: NextFunction) {
  if (!this.getQuery().includeDeleted) {
    this.where({ deletedAt: null });
  }
  next();
});

export const UserReadModel = mongoose.model<IUserReadModel>(
  "User",
  UserReadSchema
);

// --- Student Discriminator ---
const StudentReadSchema = new Schema<IStudentReadModel>({
  classId: { type: String, index: true },
  educationLevel: { type: String, required: true },
  gradeGroup: { type: String, required: true },
  guardianName: String,
  guardianPhone: String,
  meta: { type: Schema.Types.Mixed, default: {} }, // Still Mixed, but we can refine later
});

export const StudentReadModel = UserReadModel.discriminator<IStudentReadModel>(
  "Student",
  StudentReadSchema
);
