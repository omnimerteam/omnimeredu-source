import { Model } from "mongoose";
import { BaseRepository } from "./base.repository";
import { IStudent } from "../models/Student";

class StudentRepository extends BaseRepository<IStudent> {
  constructor(studentModel: Model<IStudent>) {
    super(studentModel);
  }

  async assignClassToStudents(
    studentIds: string[],
    classId: string
  ): Promise<any> {
    return this.model.updateMany(
      { _id: { $in: studentIds } },
      { $set: { classId } }
    );
  }

  async clearClassIdForStudents(studentIds: string[]): Promise<any> {
    return this.model.updateMany(
      { _id: { $in: studentIds } },
      { $unset: { classId: "" } }
    );
  }
}

export default StudentRepository;
