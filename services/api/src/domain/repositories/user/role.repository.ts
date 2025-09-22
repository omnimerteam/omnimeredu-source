import { Model } from "mongoose";
import { BaseRepository } from "../base.repository";
import { IRole } from "../../models";

class RoleRepository extends BaseRepository<IRole> {
  constructor(roleModel: Model<IRole>) {
    super(roleModel);
  }

  async findByRoleName(roleName: string) {
    try {
      return await this.model.findOne({ name: roleName });
    } catch (e) {
      throw e;
    }
  }
}

export default RoleRepository;
