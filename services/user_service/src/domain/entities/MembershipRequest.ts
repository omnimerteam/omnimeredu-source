import {
  MembershipRoleEnum,
  MembershipActionEnum,
  MembershipStatusEnum,
} from "shared-lib";

export class MembershipRequest {
  constructor(
    public id: string,
    public userId: string,
    public schoolId: string,
    public role: MembershipRoleEnum,
    public action: MembershipActionEnum,
    public status: MembershipStatusEnum = MembershipStatusEnum.Pending,
    public classId?: string,
    public note?: string,
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
