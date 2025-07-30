import { Schema } from 'mongoose';
import { BaseUser } from './BaseUser';

export interface ISchoolAdmin {
  schoolId: Schema.Types.ObjectId;
}

const SchoolAdminSchema = new Schema<ISchoolAdmin>({
  schoolId: { type: Schema.Types.ObjectId, ref: 'School', required: true }
},
);

export default BaseUser.discriminator<ISchoolAdmin>("SchoolAdmin", SchoolAdminSchema);