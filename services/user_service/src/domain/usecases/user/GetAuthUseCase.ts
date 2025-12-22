import { IUserRepository } from "../../repositories/IUserRepository";
import { User } from "../../entities/User";
import { Account } from "../../entities/Account";
import { AuthUtils } from "../../../infrastructure/utils/AuthUtils";

export interface GetAuthRequest {
  accessToken: string;
}

export interface GetAuthResponse {
  user: User;
  account: Account;
}

export class GetAuthUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute(request: GetAuthRequest): Promise<GetAuthResponse> {
    // 1. Verify access token
    let payload;
    try {
      payload = AuthUtils.verifyAccessToken(request.accessToken);
    } catch (error) {
      throw new Error(
        error instanceof Error ? error.message : "Invalid access token"
      );
    }

    // 2. Find user by userId from token
    const user = await this.userRepository.findById(payload.userId);
    if (!user) {
      throw new Error("User not found");
    }

    // 3. Find account by userId
    const account = await this.userRepository.findAccountByUserId(
      payload.userId
    );
    if (!account) {
      throw new Error("Account not found");
    }

    // 4. Check if account is active
    if (!account.isActive) {
      throw new Error("Account is inactive");
    }

    return {
      user,
      account,
    };
  }
}
