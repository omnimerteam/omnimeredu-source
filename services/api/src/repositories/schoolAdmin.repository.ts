import { Model } from "mongoose";
import { BaseRepository } from "./base.repository";
import { ISchoolAdmin } from "../models/SchoolAdmin";

class SchoolAdminRepository extends BaseRepository<ISchoolAdmin> {
  constructor(schoolAdminModel: Model<ISchoolAdmin>) {
    super(schoolAdminModel);
  }
}

export default SchoolAdminRepository;
