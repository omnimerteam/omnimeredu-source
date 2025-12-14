import { IUserRepository } from "../../domain/repositories/IUserRepository";
import { User } from "../../domain/entities/User";
import { Account } from "../../domain/entities/Account";
import { UserModel } from "../datasources/postgres/models/UserModel";
import { StudentModel } from "../datasources/postgres/models/StudentModel";
import { TeacherModel } from "../datasources/postgres/models/TeacherModel";
import { SchoolAdminModel } from "../datasources/postgres/models/SchoolAdminModel";
import { AccountModel } from "../datasources/postgres/models/AccountModel";

export class UserRepositoryImpl implements IUserRepository {
  async createStudentProfile(userId: string, data: any): Promise<void> {
    await StudentModel.create({
      userId,
      classId: data.classId,
      educationLevel: data.educationLevel,
      gradeGroup: data.gradeGroup,
      guardianName: data.guardianName,
      guardianPhone: data.guardianPhone,
      meta: data.meta,
    });
  }

  async createTeacherProfile(userId: string, data: any): Promise<void> {
    await TeacherModel.create({
      userId,
      qualification: data.qualification,
      subjects: data.subjects,
    });
  }

  async createSchoolAdminProfile(userId: string, data: any): Promise<void> {
    await SchoolAdminModel.create({
      userId,
      position: data.position,
    });
  }

  async create(user: User): Promise<User> {
    const userModel = await UserModel.create({
      fullName: user.fullName,
      roleKey: user.roleKey,
      email: user.email,
      gender: user.gender,
      birthday: user.birthday,
      phone: user.phone,
      address: user.address,
      isVerified: user.isVerified,
      avatarUrl: user.avatarUrl,
      schoolId: user.schoolId,
    });
    return this.toUserEntity(userModel);
  }

  async findById(id: string): Promise<User | null> {
    const userModel = await UserModel.findByPk(id);
    if (!userModel) return null;
    return this.toUserEntity(userModel);
  }

  async findByEmail(email: string): Promise<User | null> {
    const userModel = await UserModel.findOne({ where: { email } });
    if (!userModel) return null;
    return this.toUserEntity(userModel);
  }

  async update(user: User): Promise<User> {
    const [affectedCount, updatedModels] = await UserModel.update(
      {
        fullName: user.fullName,
        roleKey: user.roleKey,
        email: user.email,
        gender: user.gender,
        birthday: user.birthday,
        phone: user.phone,
        address: user.address,
        isVerified: user.isVerified,
        avatarUrl: user.avatarUrl,
        schoolId: user.schoolId,
      },
      {
        where: { id: user.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("User not found or not updated");
    }

    return this.toUserEntity(updatedModels[0]);
  }

  async updateAvatar(userId: string, avatarUrl: string): Promise<void> {
    await UserModel.update({ avatarUrl }, { where: { id: userId } });
  }

  async createAccount(account: Account): Promise<Account> {
    const accountModel = await AccountModel.create({
      userId: account.userId,
      email: account.email,
      passwordHash: account.passwordHash,
      uid: account.uid,
      isActive: account.isActive,
      lastLogin: account.lastLogin,
    });
    return this.toAccountEntity(accountModel);
  }

  async findAccountByEmail(email: string): Promise<Account | null> {
    const accountModel = await AccountModel.findOne({ where: { email } });
    if (!accountModel) return null;
    return this.toAccountEntity(accountModel);
  }

  async findAccountByUid(uid: string): Promise<Account | null> {
    const accountModel = await AccountModel.findOne({ where: { uid } });
    if (!accountModel) return null;
    return this.toAccountEntity(accountModel);
  }

  async findAccountByUserId(userId: string): Promise<Account | null> {
    const accountModel = await AccountModel.findOne({ where: { userId } });
    if (!accountModel) return null;
    return this.toAccountEntity(accountModel);
  }

  async updateLastLogin(accountId: string): Promise<void> {
    await AccountModel.update(
      { lastLogin: new Date() },
      { where: { id: accountId } }
    );
  }

  async updateAccountPassword(
    userId: string,
    newPasswordHash: string
  ): Promise<void> {
    await AccountModel.update(
      { passwordHash: newPasswordHash },
      { where: { userId } }
    );
  }

  private toUserEntity(model: UserModel): User {
    return new User(
      model.id,
      model.fullName,
      model.roleKey,
      model.email,
      model.gender,
      model.birthday,
      model.phone,
      model.address,
      model.isVerified,
      model.avatarUrl,
      model.schoolId,
      model.deletedAt
    );
  }

  async updateUserSchool(userId: string, schoolId: string): Promise<void> {
    await UserModel.update(
      { schoolId },
      { where: { id: userId } }
    );
  }

  async createSchool(data: {
    name: string;
    address: string;
    phone?: string;
    description?: string;
    level: string;
  }): Promise<{ id: string; name: string }> {
    // Import SchoolModel dynamically to avoid circular dependency
    const { SchoolModel } = await import("../datasources/postgres/models/SchoolModel");

    const school = await SchoolModel.create({
      name: data.name,
      address: data.address,
      phone: data.phone,
      description: data.description,
      level: data.level,
    });

    return {
      id: school.id,
      name: school.name,
    };
  }

  private toAccountEntity(model: AccountModel): Account {
    return new Account(
      model.id,
      model.userId,
      model.email,
      model.passwordHash,
      model.uid,
      model.isActive,
      model.lastLogin
    );
  }
}
