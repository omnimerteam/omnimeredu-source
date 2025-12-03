export enum Gender {
  Male = "Male",
  Female = "Female",
  Other = "Other",
}

export enum RoleGroup {
  Student = "Student",
  Teacher = "Teacher",
  SchoolAdmin = "SchoolAdmin",
  SuperAdmin = "SuperAdmin",
  Staff = "Staff",
}

export class User {
  constructor(
    public id: string,
    public fullName: string,
    public roleKey: RoleGroup,
    public email?: string, // Contact email
    public gender?: Gender,
    public birthday?: Date,
    public phone?: string,
    public address?: string,
    public isVerified: boolean = false,
    public avatarUrl?: string,
    public schoolId?: string | null,
    public deletedAt?: Date | null
  ) {}
}
