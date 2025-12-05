import { TeacherQualificationEnum, SubjectEnum } from "shared-lib";

export class Teacher {
  constructor(
    public id: string,
    public userId: string,
    public qualification?: TeacherQualificationEnum,
    public subjects?: SubjectEnum[],
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
