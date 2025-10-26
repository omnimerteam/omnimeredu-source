import { RoleGroup } from "../../../common/enum/role.enum";
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

  async updateRoleId(
    actorId: string,
    userRole: string,
    id: string,
    roleId: string
  ) {
    try {
      const updatePersonnel = await this.personnelRepository.update(id, {
        roleId: roleId,
      });

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_ROLE_ID_PERSONNEL",
        roleSnapshot: userRole,
        metadata: { updateData: { id: id, roleId: roleId } },
      });

      return updatePersonnel;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_ROLE_ID_PERSONNEL_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateVerified(
    actorId: string,
    userRole: string,
    id: string,
    isVerified: boolean
  ) {
    try {
      const updatePersonnel = await this.personnelRepository.update(id, {
        isVerified: isVerified,
      });

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_VERIFIED_PERSONNEL",
        roleSnapshot: userRole,
        metadata: { updateData: { id: id, isVerified: isVerified } },
      });

      return updatePersonnel;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_VERIFIED_PERSONNEL_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async dismissPersonnel(actorId: string, userRole: string, id: string) {
    try {
      const updatePersonnel = await this.personnelRepository.update(id, {
        schoolId: null,
      });

      await this.logger.log({
        userId: actorId,
        action: "DISMISS_PERSONNEL",
        roleSnapshot: userRole,
        metadata: { personnelDismissed: id },
      });

      return updatePersonnel;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DISMISS_PERSONNEL_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getUserById(id: string) {
    try {
      return await this.personnelRepository.findById(id);
    } catch (error) {
      throw error;
    }
  }

  async updateAvatar(actorId: string, avatarPath: string, avatarUrl: string) {
    try {
      return await this.personnelRepository.update(actorId, {
        avatarPath: avatarPath,
        avatarUrl: avatarUrl,
      });
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_AVATAR_FAILED",
        metadata: { error: (error as Error).message },
      });

      throw error;
    }
  }
}

export default PersonnelService;
