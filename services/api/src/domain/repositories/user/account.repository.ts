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
          "qualification",
          "educationLevel",
          "grade",
          "roleId",
          "schoolId",
          "classId",
          "avatarUrl",
        ].join(" "),
        populate: [
          { path: "roleId", select: "_id name" },
          { path: "schoolId", select: "_id name level" },
          { path: "classId", select: "_id name" },
        ],
      }); // nếu muốn return plain object
  }

  /**
   * Tìm account theo userId
   * Trả về Account kèm User + Role (dùng cho JWT getMe)
   */
  async findUserByUserId(userId: string) {
    return this.model.findOne({ userId }).populate({
      path: "userId",
      select: [
        "fullName",
        "isVerified",
        "position",
        "qualification",
        "educationLevel",
        "grade",
        "roleId",
        "schoolId",
        "classId",
        "avatarUrl",
      ].join(" "),
      populate: [
        { path: "roleId", select: "_id name" },
        { path: "schoolId", select: "_id name level" },
        { path: "classId", select: "_id name" },
      ],
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

  /**
   * Tìm account theo email
   * Trả về Account kèm User + Role (dùng cho JWT login)
   */
  async findAccountByEmail(email: string) {
    return this.model.findOne({ email }).populate({
      path: "userId",
      select: [
        "fullName",
        "isVerified",
        "position",
        "qualification",
        "educationLevel",
        "grade",
        "roleId",
        "schoolId",
        "classId",
        "avatarUrl",
      ].join(" "),
      populate: [
        { path: "roleId", select: "_id name" },
        { path: "schoolId", select: "_id name level" },
        { path: "classId", select: "_id name" },
      ],
    });
  }

  /**
   * Cập nhật refresh token cho account
   */
  async updateRefreshToken(
    userId: string,
    refreshToken: string | null,
    options: { session?: mongoose.ClientSession } = {}
  ) {
    return this.model.updateOne({ userId }, { refreshToken }, options);
  }

  /**
   * Tìm account theo refresh token
   */
  async findByRefreshToken(refreshToken: string) {
    return this.model.findOne({ refreshToken }).populate({
      path: "userId",
      select: [
        "fullName",
        "isVerified",
        "roleId",
        "schoolId",
        "classId",
        "avatarUrl",
      ].join(" "),
      populate: [
        { path: "roleId", select: "_id name" },
        { path: "schoolId", select: "_id name level" },
        { path: "classId", select: "_id name" },
      ],
    });
  }
}

export default AccountRepository;
