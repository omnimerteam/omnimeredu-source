import { DefaultLogger } from "../../../common/utils/DefaultLogger.js";
import { RoleRepository } from "../../repositories";

class RoleService {
  private readonly logger: DefaultLogger;
  private readonly roleRepository: RoleRepository;

  constructor(roleRepository: RoleRepository, DefaultLogger: DefaultLogger) {
    this.logger = DefaultLogger;
    this.roleRepository = roleRepository;
  }

  async getAllRoles() {
    try {
      const roles = await this.roleRepository.findAll({
        name: { $ne: "SchoolAdmin" },
      });
      return roles;
    } catch (error) {
      throw error;
    }
  }
}
export default RoleService;
