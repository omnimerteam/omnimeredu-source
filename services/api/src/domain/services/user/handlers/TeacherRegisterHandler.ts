import { ClientSession } from "mongoose";
import { MembershipRequestRepository } from "../../../repositories";
import { IRegisterHandler } from "./IRegisterHandler";
import {
  MembershipActionEnum,
  MembershipRoleEnum,
  MembershipStatusEnum,
} from "../../../../common/enum/membershipRequest.enum";

export class TeacherRegisterHandler implements IRegisterHandler {
  private readonly memberShipRepository: MembershipRequestRepository;
  constructor(memberShipRepository: MembershipRequestRepository) {
    this.memberShipRepository = memberShipRepository;
  }
  async handle(user: any, payload: any, session: ClientSession) {
    if (payload.schoolId) {
      await this.memberShipRepository.createWithSession(
        {
          userId: user._id,
          schoolId: payload.schoolId,
          role: MembershipRoleEnum.Teacher,
          action: MembershipActionEnum.Enroll,
          status: MembershipStatusEnum.Pending,
        },
        session
      );
    }
  }
}
