import { ClientSession } from "mongoose";
import { MembershipRequestRepository } from "../../../repositories";
import { IRegisterHandler } from "./IRegisterHandler";

export class StudentRegisterHandler implements IRegisterHandler {
  private readonly memberShipRepository: MembershipRequestRepository;
  constructor(memberShipRepository: MembershipRequestRepository) {
    this.memberShipRepository = memberShipRepository;
  }

  async handle(user: any, payload: any, session: ClientSession) {
    if (!payload.schoolId) {
      throw new Error("schoolId is required for student registration");
    }

    await this.memberShipRepository.createWithSession(
      {
        userId: user._id,
        schoolId: payload.schoolId,
        classId: payload.classId ?? undefined,
        role: "Student",
        action: "Enroll",
        status: "Pending",
      },
      session
    );
  }
}
