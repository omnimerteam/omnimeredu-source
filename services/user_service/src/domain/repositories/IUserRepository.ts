import { User } from "../entities/User";
import { Account } from "../entities/Account";

export interface IUserRepository {
  // User methods
  create(user: User): Promise<User>;
  findById(id: string): Promise<User | null>;
  update(user: User): Promise<User>;

  // Account methods
  createAccount(account: Account): Promise<Account>;
  findAccountByEmail(email: string): Promise<Account | null>;
  findAccountByUid(uid: string): Promise<Account | null>;
}
