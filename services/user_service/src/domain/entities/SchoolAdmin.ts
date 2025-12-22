import { SchoolAdminPositionEnum } from "shared-lib";

export class SchoolAdmin {
  constructor(
    public id: string,
    public userId: string,
    public position?: SchoolAdminPositionEnum,
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
