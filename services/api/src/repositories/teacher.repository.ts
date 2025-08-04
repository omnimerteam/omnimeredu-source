import { BaseRepository } from "./base.repository";
import { ITeacher } from "../models/Teacher";
import { Model } from "mongoose";

class TeacherRepository extends BaseRepository<ITeacher> {

    constructor(Teacher: Model<ITeacher>) {
        super(Teacher);
    }

    async findBySchoolId(schoolId: string) {
        return this.model.find({ schoolId }).exec();
    }

    async findBySubject(subject: string) {
        return this.model.find({ subjects: subject }).exec();
    }

    async findByUserId(userId: string) {
        return this.model.find({ userId }).exec();
    }
}

export default TeacherRepository;
