import { Schema } from 'mongoose';
import { BaseUser } from './BaseUser';

export const SchoolAdmin = BaseUser.discriminator('SchoolAdmin', new Schema({
  schoolId: { type: Schema.Types.ObjectId, ref: 'School', required: true }
}));