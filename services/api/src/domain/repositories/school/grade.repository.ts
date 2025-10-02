import { Model } from "mongoose";
import { IGrade } from "../../models";
import { BaseRepository } from "../base.repository";

class GradeRepository extends BaseRepository<IGrade> {
  constructor(model: Model<IGrade>) {
    super(model);
  }

  /**
   * Lấy danh sách Grade phục vụ selectbox
   * Chỉ lấy các field _id, name, level, order, ageRange
   * Có thể lọc theo schoolId
   */
  async findForSelect(schoolId?: string) {
    const filter: any = { active: true };
    if (schoolId) filter.schoolId = schoolId;
    console.log(filter);
    return this.model
      .find(filter)
      .select("_id name level order ageRange")
      .sort({ order: 1 })
      .exec(); // lean() trả về plain object, nhẹ hơn document
  }
}

export default GradeRepository;
