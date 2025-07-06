import { Schema } from 'mongoose';
import { BaseUser } from './BaseUser';

export const SuperAdmin = BaseUser.discriminator('SuperAdmin', new Schema({}));