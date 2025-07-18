import { Model } from "mongoose";
import { IClass } from "../models/Class";
import { BaseRepository } from "./base.repository";

class ClassRepository extends BaseRepository<IClass> {
  constructor(ClassModel: Model<IClass>) {
    super(ClassModel);
  }

  /**
   * Hàm mở rộng riêng của ClassRepository
   */
  async findByCode(code: string): Promise<IClass | null> {
    return this.model.findOne({ code }).exec();
  }
}

export default ClassRepository;
