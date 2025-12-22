import { IUserRepository } from "../../repositories/IUserRepository";
import { User } from "../../entities/User";
import { Account } from "../../entities/Account";
import { AuthUtils } from "../../../infrastructure/utils/AuthUtils";

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  user: User;
  account: Account;
  tokens: {
    accessToken: string;
    refreshToken: string;
  };
}

export class LoginUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute(request: LoginRequest): Promise<LoginResponse> {
    // 1. Find account by email
    const account = await this.userRepository.findAccountByEmail(request.email);
    if (!account) {
      throw new Error("Invalid email or password");
    }

    // 2. Check if account is active
    if (!account.isActive) {
      throw new Error("Account is inactive");
    }

    // 3. Verify password
    const isPasswordValid = await AuthUtils.comparePassword(
      request.password,
      account.passwordHash
    );
    if (!isPasswordValid) {
      throw new Error("Invalid email or password");
    }

    // 4. Find user by userId
    const user = await this.userRepository.findById(account.userId);
    if (!user) {
      throw new Error("User not found");
    }

    // 5. Update last login timestamp
    await this.userRepository.updateLastLogin(account.id);

    // 6. Generate JWT tokens
    const tokens = AuthUtils.generateTokenPair({
      userId: user.id,
      email: user.email || request.email,
      roleKey: user.roleKey,
    });

    // 7. Update account with new lastLogin value
    account.lastLogin = new Date();

    return {
      user,
      account,
      tokens,
    };
  }
}
