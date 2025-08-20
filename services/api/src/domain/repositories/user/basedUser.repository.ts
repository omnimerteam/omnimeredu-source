import { IBaseUser, BaseUser } from "../../models";
import { FilterQuery } from "mongoose";

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
// export const findAll = async (): Promise<IBaseUser[]> => {
//   return await BaseUser.find().exec();
// };

export const findAll = async (
  filter: FilterQuery<IBaseUser> = {},
  skip = 0,
  limit = 20
): Promise<IBaseUser[]> => {
  return await BaseUser.find(filter).skip(skip).limit(limit).exec();
};
