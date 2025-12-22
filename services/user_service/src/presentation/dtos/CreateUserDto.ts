import { GenderEnum, RoleGroup } from "shared-lib";

export class CreateUserDto {
  fullName!: string;
  roleKey!: RoleGroup;
  email?: string;
  gender?: GenderEnum;
  birthday?: Date;
  phone?: string;
  address?: string;
  avatarUrl?: string;
  schoolId?: string;
}
