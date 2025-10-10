import mongoose, { Model, Types } from "mongoose";
import { IAccount, Account } from "../../models";

/**
 * Repository quản lý Account
 * Chịu trách nhiệm tương tác trực tiếp với MongoDB
 */
class AccountRepository {
  private readonly model: Model<IAccount>;

  constructor(model: Model<IAccount>) {
    this.model = model;
  }

  /**
   * Tạo mới Account
   */
  async createAccount(
    data: Partial<IAccount>,
    options: { session?: mongoose.ClientSession } = {}
  ): Promise<IAccount> {
    return this.model.create([data], options).then((res) => res[0]);
  }

  /**
   * Xóa account theo userId
   * @param userId
   * @returns số lượng document bị xóa
   */
  async deleteAccountByUserId(userId: string): Promise<boolean> {
    if (!Types.ObjectId.isValid(userId)) return false;
    const result = await this.model.findByIdAndDelete(userId).exec();
    return result !== null;
  }

  /**
   * Tìm account theo Firebase UID
   * Trả về Account kèm User + Role
   */
  async findUserByUidForSystem(uid: string) {
    return this.model
      .findOne({ uid })
      .select("email uid userId")
      .populate({
        path: "userId",
        select: "roleId schoolId classId", // chỉ những field cần
        populate: [{ path: "roleId", select: "name" }],
      });
  }

  async findUserByUid(uid: string) {
    return this.model
      .findOne({ uid })
      .select("uid email") // parent fields
      .populate({
        path: "userId",
        select: [
          "fullName",
          "isVerified",
          "position",
          "literacy",
          "educationLevel",
          "grade",
          "roleId",
          "schoolId",
          "classId",
          "avatarUrl",
        ].join(" "),
        populate: [
          { path: "roleId", select: "name" },
          { path: "schoolId", select: "name" },
          { path: "classId", select: "name" },
        ],
      }); // nếu muốn return plain object
  }

  /**
   * Tìm account theo userId
   * Trả về Account kèm User + Role
   */
  async findUserByUserId(userId: string) {
    return this.model.findOne({ userId }).populate({
      path: "userId",
      populate: {
        path: "roleId",
        select: "name",
      },
    });
  }

  /**
   * Tìm account thô theo userId (không populate)
   */
  async findAccountByUserId(userId: string) {
    return this.model.findOne({ userId });
  }

  /**
   * Update mật khẩu (đã hash) cho account
   */
  async updateAccountPassword(
    userId: string,
    hashedPassword: string,
    options: { session?: mongoose.ClientSession } = {}
  ) {
    return this.model.updateOne(
      { userId },
      { password: hashedPassword },
      options
    );
  }
}

export default AccountRepository;
