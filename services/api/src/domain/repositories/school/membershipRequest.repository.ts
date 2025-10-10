import { Model } from "mongoose";
import { IMembershipRequest } from "../../models";
import { BaseRepository } from "../base.repository";

class MembershipRequestRepository extends BaseRepository<IMembershipRequest> {
  constructor(membershipRequest: Model<IMembershipRequest>) {
    super(membershipRequest);
  }
}

export default MembershipRequestRepository;
