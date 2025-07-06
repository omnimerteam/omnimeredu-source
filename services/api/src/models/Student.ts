import { Schema, Types } from 'mongoose';
import { BaseUser } from './BaseUser';

export const Student = BaseUser.discriminator('Student', new Schema({
  schoolId: { type: Schema.Types.ObjectId, ref: 'School', required: true },
  classId: { type: Schema.Types.ObjectId, ref: 'Class', required: true }
}));