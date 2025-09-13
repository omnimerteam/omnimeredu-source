import { ClientSession, Types } from "mongoose";
import { IRegisterHandler } from "./IRegisterHandler";
import {
  MembershipRequestRepository,
  SchoolRepository,
} from "../../../repositories";
import { createSchoolBodySchema } from "../../../../common/validators/school/school.validator";
import chalk from "chalk";
import { generateSchoolCode } from "../../../utils/generateCode";

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
    if (payload.schoolData) {
      // Trường hợp tạo mới trường
      const code = generateSchoolCode(payload.schoolData.name || "XXX YYY ZZZ");
      // Generate code from name
      console.log("Payload", payload.schoolData);
      const schoolData = createSchoolBodySchema.parse({
        ...payload.schoolData,
        adminId: user.id,
      });

      const school = await this.schoolRepository.createWithSession(
        {
          ...schoolData,
          adminId: new Types.ObjectId(schoolData.adminId),
          code,
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
