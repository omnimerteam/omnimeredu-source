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

export const deleteAccountByUserId = async (userId: string) => {
  try {
    const result = await Account.deleteOne({ userId }); // xóa account có userId
    return result.deletedCount; // trả về số document bị xóa
  } catch (error) {
    console.error("❌ deleteAccountByUserId error:", error);
    throw error;
  }
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

export const findUserByUserId = async (userId: string) => {
  return await Account.findOne({ userId }).populate({
    path: "userId",
    populate: {
      path: "roleId",
      select: "name",
    },
  });
};

// export const changePassword = async (newPasswrod: string, uid: string) => {
//   return await Account.updateOne;
// };
