import { ISchool } from "../../models";
import { Types, Model } from "mongoose";
import { BaseRepository } from "../base.repository";

class SchoolRepository extends BaseRepository<ISchool> {
  constructor(SchoolModel: Model<ISchool>) {
    super(SchoolModel);
  }
  // hàm này sẽ tìm kiếm theo tên hoặc mã trường học, nếu cả hai đều không có thì sẽ báo lỗi
  async findByNameOrCode(name: string, code: string): Promise<ISchool | null> {
    //khởi tạo 1 object rỗng
    const query: any = {};

    //Nếu user nhập cả name và code thì sẽ tìm kiếm cả 2
    // $or là toán tử bắt đầu 1 điều kiện
    //^..& sẽ đảm bảo chuỗi giống hoàn toàn, 'i' là flag để không phân biệt hoa thường
    if (name && code) {
      query.$or = [
        { name: new RegExp(`^${name}$`, "i") },
        { code: new RegExp(`^${code}$`, "i") },
      ];
      // Nếu chỉ có name thì sẽ tìm kiếm theo name
    } else if (name) {
      query.name = new RegExp(`^${name}$`, "i");
    } else {
      query.code = new RegExp(`^${code}$`, "i");
    }

    return this.model.findOne(query);
  }
}

//ở đây chỉ export ra 1 class duy nhất, không cần phải export từng hàm
export default SchoolRepository;
