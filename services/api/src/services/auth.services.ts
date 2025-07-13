import * as RoleRepo from "../repositories/role.repository";
import * as BaseUserRepo from "../repositories/basedUser.repository";
import * as AccountRepo from "../repositories/account.repository";
import { IRole } from "../models/Role";

export const registerUser = async (
  uid: string,
  email: string,
  fullName: string,
  gender: "Male" | "Female" | "Other",
  phone: string,
  role: string,
  password: string
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
    password,
    userId: baseUser._id, // đã là ObjectId rồi!
  });

  return baseUser;
};

export const getRoleByUid = async (uid: string) => {
  const account = await AccountRepo.findUserByUid(uid);
  if (!account) throw new Error("User not found");

  const user = account.userId as any;
  let roleName: string | undefined;

  if (user && typeof user === "object" && "roleId" in user) {
    // Nếu roleId đã populate
    const role = user.roleId as IRole;
    roleName =
      typeof role === "object" && role !== null ? role.name : undefined;
  }

  return roleName;
};
