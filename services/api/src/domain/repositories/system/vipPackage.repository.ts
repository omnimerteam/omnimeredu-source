import { Model } from "mongoose";
import { BaseRepository } from "../base.repository";
import { IVipPackage } from "../../models";

class VipPackageRepository extends BaseRepository<IVipPackage> {
  constructor(VipPackageModel: Model<IVipPackage>) {
    super(VipPackageModel);
  }
}

export default VipPackageRepository;
