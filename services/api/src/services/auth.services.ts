import * as RoleRepo from "../repositories/role.repository";
import * as BaseUserRepo from "../repositories/basedUser.repository";
import * as AccountRepo from "../repositories/account.repository";

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

async function createAccountAndUser(data: {
  email: string;
  password: string;
  roleName: string; // vd: 'Teacher'
  userInfo: any; // data riêng cho BaseUser
}) {
  const role = await RoleRepo.findRoleByName(data.roleName);
  if (!role) throw new Error("Role không hợp lệ");

  // 1. Tạo BaseUser hoặc subclass
  const UserModel = roleToModelMap[data.roleName];
  if (!UserModel) throw new Error("Không tìm được model tương ứng với role");

  const user = await UserModel.create(data.userInfo);

  // 2. Tạo Account
  const account = await AccountRepo.create({
    email: data.email,
    password: hashPassword(data.password),
    uid: "", // nếu dùng Firebase thì lưu uid ở đây
    roleId: role._id,
    userRef: user._id,
  });

  return account;
}
