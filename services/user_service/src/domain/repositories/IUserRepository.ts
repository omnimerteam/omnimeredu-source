import { User } from "../entities/User";
import { Account } from "../entities/Account";

export interface IUserRepository {
  // Transaction management
  startTransaction(): Promise<any>;
  commitTransaction(transaction: any): Promise<void>;
  rollbackTransaction(transaction: any): Promise<void>;

  // User methods
  create(user: User, options?: { transaction?: any }): Promise<User>;
  createStudentProfile(
    userId: string,
    data: any,
    options?: { transaction?: any }
  ): Promise<void>;
  createTeacherProfile(
    userId: string,
    data: any,
    options?: { transaction?: any }
  ): Promise<void>;
  createSchoolAdminProfile(
    userId: string,
    data: any,
    options?: { transaction?: any }
  ): Promise<void>;
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  update(user: User, options?: { transaction?: any }): Promise<User>;
  updateAvatar(
    userId: string,
    avatarUrl: string,
    options?: { transaction?: any }
  ): Promise<void>;
  updateUserSchool(
    userId: string,
    schoolId: string,
    options?: { transaction?: any }
  ): Promise<void>;

  // School methods
  createSchool(
    data: {
      name: string;
      code: string;
      address: string;
      phone?: string;
      description?: string;
      level: string;
    },
    options?: { transaction?: any }
  ): Promise<{ id: string; name: string }>;

  // Account methods
  createAccount(
    account: Account,
    options?: { transaction?: any }
  ): Promise<Account>;
  findAccountByEmail(email: string): Promise<Account | null>;
  findAccountByUserId(userId: string): Promise<Account | null>;
  updateLastLogin(accountId: string): Promise<void>;
  updateAccountPassword(userId: string, newPasswordHash: string): Promise<void>;
}
