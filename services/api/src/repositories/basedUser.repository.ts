import { BaseUser, IBaseUser } from "../models/BaseUser";

/**
 * Tạo mới BaseUser
 */
export const createBaseUser = async (
  data: Partial<IBaseUser>
): Promise<IBaseUser> => {
  const newUser = new BaseUser(data);
  return await newUser.save();
};

/**
 * Tìm user theo username
 */
export const findByUsername = async (
  username: string
): Promise<IBaseUser | null> => {
  return await BaseUser.findOne({ username }).exec();
};

/**
 * Tìm user theo ID
 */
export const findById = async (id: string): Promise<IBaseUser | null> => {
  return await BaseUser.findById(id).exec();
};

/**
 * Lấy tất cả user (tuỳ mục đích)
 */
export const findAll = async (): Promise<IBaseUser[]> => {
  return await BaseUser.find().exec();
};
