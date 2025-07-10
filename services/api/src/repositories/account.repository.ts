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
 */
export const findAccountByUid = async (
  uid: string
): Promise<IAccount | null> => {
  return await Account.findOne({ uid }).populate("userId").exec();
};
