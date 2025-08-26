import { ClientSession, Types } from "mongoose";
import { IRegisterHandler } from "./IRegisterHandler";
import {
  MembershipRequestRepository,
  SchoolRepository,
} from "../../../repositories";
import { createSchoolBodySchema } from "../../../../common/validators/school/school.validator";
import chalk from "chalk";

export class SchoolAdminRegisterHandler implements IRegisterHandler {
  private readonly schoolRepository: SchoolRepository;
  private readonly memberShipRepository: MembershipRequestRepository;
  constructor(
    schoolRepository: SchoolRepository,
    memberShipRepository: MembershipRequestRepository
  ) {
    this.schoolRepository = schoolRepository;
    this.memberShipRepository = memberShipRepository;
  }

  async handle(user: any, payload: any, session: ClientSession) {
    console.log(payload);
    console.log(user);
    if (payload.schoolData) {
      // Trường hợp tạo mới trường
      const schoolData = createSchoolBodySchema.parse({
        ...payload.schoolData,
        adminId: user.id,
      });

      const school = await this.schoolRepository.createWithSession(
        {
          ...schoolData,
          adminId: new Types.ObjectId(schoolData.adminId),
        },
        session
      );

      user.schoolId = school._id;

      await user.save({ session });
    } else if (payload.schoolId) {
      // Trường hợp xin vào trường có sẵn
      await this.memberShipRepository.createWithSession(
        {
          userId: user._id,
          schoolId: payload.schoolId,
          role: "SchoolAdmin",
          action: "Enroll",
          status: "Pending",
        },
        session
      );
    }
  }
}
