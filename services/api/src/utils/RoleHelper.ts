import { IRole } from "../models";

/**
 * Trích xuất tên role từ object user bất kỳ.
 * Trả về undefined nếu không xác định được.
 */
export const extractRoleName = (user: any): string | undefined => {
  if (!user || typeof user !== "object") return undefined;

  const role = user.roleId as IRole;

  if (role && typeof role === "object" && "name" in role) {
    return role.name;
  }

  return undefined;
};
