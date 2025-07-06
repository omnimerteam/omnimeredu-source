import { Schema } from 'mongoose';
import { BaseUser } from './BaseUser';

export const Teacher = BaseUser.discriminator('Teacher', new Schema({
  literacy: String,
  subjects: [String]
}));