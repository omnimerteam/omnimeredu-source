import { Model } from "mongoose";
import { BaseRepository } from "../../base.repository";
import { IClassDetailView } from "../../../models";

class ClassDetailViewRepository extends BaseRepository<IClassDetailView> {
  constructor(classDetailViewModel: Model<IClassDetailView>) {
    super(classDetailViewModel);
  }
}

export default ClassDetailViewRepository;
