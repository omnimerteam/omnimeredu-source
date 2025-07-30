import { Model } from "mongoose";
import { BaseRepository } from "./base.repository";
import { ISuperAdmin } from "../models/SuperAdmin";

class SuperAdminRepository extends BaseRepository<ISuperAdmin> {
  constructor(superAdminModel: Model<ISuperAdmin>) {
    super(superAdminModel);
  }
}

export default SuperAdminRepository;
