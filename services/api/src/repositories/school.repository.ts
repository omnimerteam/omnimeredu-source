import { ISchool } from "../models/School";
import { Types, Model } from "mongoose";

class SchoolRepository {
    // Bắt buộc phải khai báo Model<ISchool> để sử dụng các phương thức của mongoose
    private SchoolModel: Model<ISchool>;

    constructor(SchoolModel: Model<ISchool>) {
        this.SchoolModel = SchoolModel;

    }
    async findAll(): Promise<ISchool[]> {
        return this.SchoolModel.find().exec();
    }

    async findById(id: string): Promise<ISchool | null> {
        if (!Types.ObjectId.isValid(id)) return null;
        return this.SchoolModel.findById(id).exec();
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
                { name: new RegExp(`^${name}$`, 'i') },
                { code: new RegExp(`^${code}$`, 'i') }
            ];
            // Nếu chỉ có name thì sẽ tìm kiếm theo name
        } else if (name) {
            query.name = new RegExp(`^${name}$`, 'i');
        } else {
            query.code = new RegExp(`^${code}$`, 'i');
        }

        return this.SchoolModel.findOne(query);
    }


    async create(schoolData: Partial<ISchool>): Promise<ISchool> {
        return this.SchoolModel.create(schoolData);
    }

    async update(id: string, schoolData: Partial<ISchool>): Promise<ISchool | null> {
        if (!Types.ObjectId.isValid(id)) return null;

        return this.SchoolModel.findByIdAndUpdate(id, schoolData, { new: true }).exec();
    }

    async delete(id: string): Promise<boolean> {
        if (!Types.ObjectId.isValid(id)) return false;

        const result = await this.SchoolModel.findByIdAndDelete(id).exec();
        return result !== null;
    }
}

//ở đây chỉ export ra 1 class duy nhất, không cần phải export từng hàm
export default SchoolRepository;
