import { IUserRepository } from "../../repositories/IUserRepository";
import {
  AuthUtils,
  TokenPayload,
} from "../../../infrastructure/utils/AuthUtils";

export interface RefreshAccessTokenRequest {
  refreshToken: string;
}

export interface RefreshAccessTokenResponse {
  accessToken: string;
  refreshToken: string;
}

export class RefreshAccessTokenUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute(
    request: RefreshAccessTokenRequest
  ): Promise<RefreshAccessTokenResponse> {
    // 1. Verify refresh token
    let payload: TokenPayload;
    try {
      payload = AuthUtils.verifyRefreshToken(request.refreshToken);
    } catch (error) {
      throw new Error(
        error instanceof Error ? error.message : "Invalid refresh token"
      );
    }

    // 2. Verify user still exists and is active
    const account = await this.userRepository.findAccountByUserId(
      payload.userId
    );
    if (!account) {
      throw new Error("Account not found");
    }

    if (!account.isActive) {
      throw new Error("Account is inactive");
    }

    // 3. Verify user exists
    const user = await this.userRepository.findById(payload.userId);
    if (!user) {
      throw new Error("User not found");
    }

    // 4. Generate new token pair
    const tokens = AuthUtils.generateTokenPair({
      userId: user.id,
      email: user.email || account.email,
      roleKey: user.roleKey,
    });

    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }
}
