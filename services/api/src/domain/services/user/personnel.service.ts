import { PaginationQueryOptions } from "../../../common/utils/buildQueryOptions";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { buildPermissionFilter } from "../../../common/utils/permissionFilter";
import { PersonnelRepository } from "../../repositories";

class PersonnelService {
  private personnelRepository: PersonnelRepository;
  private logger: DefaultLogger;

  constructor(personnelRepository: PersonnelRepository, logger: DefaultLogger) {
    this.personnelRepository = personnelRepository;
    this.logger = logger;
  }

  async getAllPersonnel(
    actorId: string,
    userRole: string,
    schoolId?: string,
    options?: PaginationQueryOptions
  ) {
    try {
      const filter = buildPermissionFilter(userRole, schoolId);
      // lấy danh sách teacher
      const personnel = await this.personnelRepository.findAllPersonnel(
        filter,
        options
      );

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_PERSONNEL",
        roleSnapshot: userRole,
        metadata: { personnelCount: personnel.length },
      });

      return personnel;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_PERSONNEL_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default PersonnelService;
