import { User } from "../entities/User";
import { Account } from "../entities/Account";

export interface IUserRepository {
  // User methods
  create(user: User): Promise<User>;
  createStudentProfile(userId: string, data: any): Promise<void>;
  createTeacherProfile(userId: string, data: any): Promise<void>;
  createSchoolAdminProfile(userId: string, data: any): Promise<void>;
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  update(user: User): Promise<User>;
  updateAvatar(userId: string, avatarUrl: string): Promise<void>;
  updateUserSchool(userId: string, schoolId: string): Promise<void>;

  // School methods
  createSchool(data: {
    name: string;
    address: string;
    phone?: string;
    description?: string;
    level: string;
  }): Promise<{ id: string; name: string }>;

  // Account methods
  createAccount(account: Account): Promise<Account>;
  findAccountByEmail(email: string): Promise<Account | null>;
  findAccountByUid(uid: string): Promise<Account | null>;
  findAccountByUserId(userId: string): Promise<Account | null>;
  updateLastLogin(accountId: string): Promise<void>;
  updateAccountPassword(userId: string, newPasswordHash: string): Promise<void>;
}
