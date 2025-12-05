import { MembershipRequest } from "../entities/MembershipRequest";

export interface IMembershipRequestRepository {
  create(request: MembershipRequest): Promise<MembershipRequest>;
  findById(id: string): Promise<MembershipRequest | null>;
  findByUserId(userId: string): Promise<MembershipRequest[]>;
  findBySchoolId(schoolId: string): Promise<MembershipRequest[]>;
  update(request: MembershipRequest): Promise<MembershipRequest>;
  delete(id: string): Promise<boolean>;
}
