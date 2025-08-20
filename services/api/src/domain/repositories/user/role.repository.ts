import { Model } from "mongoose";
import { BaseRepository } from "../base.repository";
import { IRole } from "../../models";

class RoleRepository extends BaseRepository<IRole> {
  constructor(roleModel: Model<IRole>) {
    super(roleModel);
  }
}

export default RoleRepository;
