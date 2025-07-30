import Account, { IAccount } from "../models/Account";

/**
 * Tạo mới Account
 */
export const createAccount = async (
  data: Partial<IAccount>
): Promise<IAccount> => {
  const newAccount = new Account(data);
  return await newAccount.save();
};

/**
 * Tìm account theo Firebase UID
 * @param uid - Firebase UID
 * @return Promise<IAccount | null>
 * Trả về toàn bộ thông tin gồm Account, Profile, Role nếu tìm thấy, ngược lại trả về null
 */
export const findUserByUid = async (uid: string) => {
  return await Account.findOne({ uid }).populate({
    path: "userId",
    populate: {
      path: "roleId",
      select: "name",
    },
  });
};
