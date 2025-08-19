import { Model } from "mongoose";
import { ITeachingAssignment } from "../models/school/class/TeachingAssignment";
import { BaseRepository } from "./base.repository";

class TeachingAssignmentRepository extends BaseRepository<ITeachingAssignment> {
  constructor(TeachingAssignmentModel: Model<ITeachingAssignment>) {
    super(TeachingAssignmentModel);
  }
}

export default TeachingAssignmentRepository;
