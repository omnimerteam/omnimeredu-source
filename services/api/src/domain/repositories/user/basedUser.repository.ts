import { IBaseUser, BaseUser } from "../../models";
import { FilterQuery } from "mongoose";

/**
 * Repository cho BaseUser
 * Chịu trách nhiệm giao tiếp với MongoDB collection "BaseUser"
 */
export default class BaseUserRepository {
  private readonly baseUserModel;

  constructor() {
    this.baseUserModel = BaseUser;
  }

  /**
   * Tạo mới BaseUser
   * @param data dữ liệu người dùng
   * @returns IBaseUser đã lưu
   */
  async create(data: Partial<IBaseUser>): Promise<IBaseUser> {
    const newUser = new this.baseUserModel(data);
    return await newUser.save();
  }

  /**
   * Tìm user theo username
   * @param username tên đăng nhập
   * @returns IBaseUser hoặc null nếu không tìm thấy
   */
  async findByUsername(username: string): Promise<IBaseUser | null> {
    return await this.baseUserModel.findOne({ username }).exec();
  }

  /**
   * Tìm user theo ID
   * @param id ObjectId dạng string
   * @returns IBaseUser hoặc null nếu không tìm thấy
   */
  async findById(id: string): Promise<IBaseUser | null> {
    return await this.baseUserModel.findById(id).exec();
  }

  /**
   * Lấy danh sách user theo filter + phân trang
   * @param filter điều kiện lọc
   * @param skip bỏ qua bao nhiêu user
   * @param limit số lượng trả về
   * @returns danh sách IBaseUser[]
   */
  async findAll(
    filter: FilterQuery<IBaseUser> = {},
    skip = 0,
    limit = 20
  ): Promise<IBaseUser[]> {
    return await this.baseUserModel.find(filter).skip(skip).limit(limit).exec();
  }
}
