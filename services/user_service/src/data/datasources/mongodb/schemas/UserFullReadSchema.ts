import mongoose, { Schema } from "mongoose";

/**
 * Enhanced User Read Schema with denormalized data for fast reads
 * This schema includes joined information from related tables
 */
const UserFullReadSchema = new Schema(
  {
    _id: { type: String }, // UUID from Postgres (User ID)
    fullName: { type: String, required: true },
    roleKey: { type: String, required: true },
    email: { type: String },
    gender: { type: String },
    birthday: Date,
    phone: { type: String },
    address: String,
    isVerified: { type: Boolean, default: false },
    avatarUrl: String,
    schoolId: { type: String },
    deletedAt: { type: Date, default: null },

    // Account information (denormalized)
    account: {
      id: String,
      email: String,
      uid: String,
      isActive: Boolean,
      lastLogin: Date,
    },

    // School information (denormalized)
    school: {
      id: String,
      name: String,
      code: String,
      address: String,
      level: String,
      logoUrl: String,
    },

    // Role-specific information (denormalized based on roleKey)
    // For Student
    studentInfo: {
      studentCode: String,
      gradeId: String,
      classId: String,
      grade: {
        id: String,
        name: String,
        level: Number,
      },
      class: {
        id: String,
        name: String,
        section: String,
        capacity: Number,
      },
    },

    // For Teacher
    teacherInfo: {
      teacherCode: String,
      subject: String,
      specialization: String,
      classIds: [String], // Array of class IDs they teach
    },

    // For SchoolAdmin
    schoolAdminInfo: {
      adminCode: String,
      position: String,
      department: String,
    },

    // For SuperAdmin
    superAdminInfo: {
      level: String,
      permissions: [String],
    },

    // Membership requests (if any)
    membershipRequests: [
      {
        id: String,
        status: String,
        requestType: String,
        schoolId: String,
        classId: String,
        createdAt: Date,
      },
    ],
  },
  {
    timestamps: true,
    _id: false, // We set _id manually
    collection: "users_full",
  }
);

// Create indexes for common queries
UserFullReadSchema.index({ email: 1 });
UserFullReadSchema.index({ roleKey: 1 });
UserFullReadSchema.index({ schoolId: 1 });
UserFullReadSchema.index({ "account.uid": 1 });
UserFullReadSchema.index({ "studentInfo.classId": 1 });
UserFullReadSchema.index({ "teacherInfo.classIds": 1 });

export const UserFullReadModel = mongoose.model(
  "users_full",
  UserFullReadSchema
);
