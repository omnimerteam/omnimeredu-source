import * as RoleRepo from "../repositories/role.repository";
import * as BaseUserRepo from "../repositories/basedUser.repository";
import * as AccountRepo from "../repositories/account.repository";

export const registerUser = async (
  uid: string,
  email: string,
  fullName: string,
  gender: "Male" | "Female" | "Other",
  phone: string,
  role: string
) => {
  // 1) Tìm role
  const roleDoc = await RoleRepo.findRoleByName(role);
  if (!roleDoc) throw new Error("❌ Role không tồn tại");

  // 2) Tạo BaseUser
  const baseUser = await BaseUserRepo.createBaseUser({
    fullName,
    gender,
    phone,
    roleId: roleDoc._id, // đã là ObjectId rồi!
  });

  // 3) Tạo Account gắn userId
  await AccountRepo.createAccount({
    uid,
    email,
    userId: baseUser._id, // đã là ObjectId rồi!
  });

  return baseUser;
};

export const getUserByUid = async (uid: string) => {
  const account = await AccountRepo.findAccountByUid(uid);
  if (!account) throw new Error("❌ User not found");

  // Populate userId kèm roleId
  return {
    uid: account.uid,
    email: account.email,
    userId: account.userId, // populated User
  };
};
