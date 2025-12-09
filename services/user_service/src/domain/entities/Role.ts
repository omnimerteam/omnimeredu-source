import { RoleEnum, RoleGroup } from "shared-lib";

export class Role {
  constructor(
    public id: string,
    public name: RoleEnum,
    public group: RoleGroup,
    public description?: string,
    public permissions?: string[],
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
