import { ISchool } from "../../models";
import { Types, Model } from "mongoose";
import { BaseRepository } from "../base.repository";

class SchoolRepository extends BaseRepository<ISchool> {
  constructor(SchoolModel: Model<ISchool>) {
    super(SchoolModel);
  }
  // hàm này sẽ tìm kiếm theo tên hoặc mã trường học, nếu cả hai đều không có thì sẽ báo lỗi
  async searchSchoolByNameOrCode(query?: string): Promise<ISchool[]> {
    //khởi tạo 1 object rỗng
    const filter: any = {};

    if (query?.trim()) {
      filter.$or = [
        { name: { $regex: query, $options: "i" } },
        { code: { $regex: query, $options: "i" } },
      ];
    }

    return this.model.find(filter).select("_id name code");
  }
}

//ở đây chỉ export ra 1 class duy nhất, không cần phải export từng hàm
export default SchoolRepository;
