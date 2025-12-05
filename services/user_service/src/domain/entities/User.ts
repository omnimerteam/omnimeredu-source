import { GenderEnum, RoleGroup } from "shared-lib";

export class User {
  constructor(
    public id: string,
    public fullName: string,
    public roleKey: RoleGroup,
    public email?: string, // Contact email
    public gender?: GenderEnum,
    public birthday?: Date,
    public phone?: string,
    public address?: string,
    public isVerified: boolean = false,
    public avatarUrl?: string,
    public schoolId?: string | null,
    public deletedAt?: Date | null
  ) {}
}
