import { Request, Response, NextFunction } from "express";
import { RegisterUserUseCase } from "../../domain/usecases/user/RegisterUserUseCase";
import { LoginUseCase } from "../../domain/usecases/user/LoginUseCase";
import { RefreshAccessTokenUseCase } from "../../domain/usecases/user/RefreshAccessTokenUseCase";
import { GetAuthUseCase } from "../../domain/usecases/user/GetAuthUseCase";
import { UserRepositoryImpl } from "../../data/repositories/UserRepositoryImpl";
import { UserReadRepositoryImpl } from "../../data/repositories/UserReadRepositoryImpl";
import { MembershipRequestRepositoryImpl } from "../../data/repositories/MembershipRequestRepositoryImpl";
import { AuthUtils } from "../../infrastructure/utils/AuthUtils";
import { ResponseUtil } from "../../infrastructure/utils/ResponseUtil";
import { RegisterDto, LoginDto, RefreshTokenDto } from "../dtos/AuthDto";
import { RoleGroup } from "shared-lib";

import { RoleRepositoryImpl } from "../../data/repositories/RoleRepositoryImpl";

// Initialize repositories
// Initialize repositories
const userRepository = new UserRepositoryImpl();
const userReadRepository = new UserReadRepositoryImpl();
const membershipRequestRepository = new MembershipRequestRepositoryImpl();
const roleRepository = new RoleRepositoryImpl();

// Initialize use cases
const registerUserUseCase = new RegisterUserUseCase(
  userRepository,
  membershipRequestRepository,
  roleRepository
);
const loginUseCase = new LoginUseCase(userRepository);
const refreshAccessTokenUseCase = new RefreshAccessTokenUseCase(userRepository);
const getAuthUseCase = new GetAuthUseCase(userRepository);

export class AuthController {
  private buildUserResponse(
    user: any,
    schoolInfo?: { schoolName?: string; className?: string }
  ) {
    return {
      id: user.id || user._id, // Handle both Entity and MongoDB doc
      email: user.email,
      fullName: user.fullName,
      roleKey: user.roleKey,
      roleId: user.roleId,
      avatarUrl: user.avatarUrl,
      phone: user.phone,
      address: user.address,
      gender: user.gender,
      birthday: user.birthday,
      schoolId: user.schoolId,
      isVerified: user.isVerified,
      schoolName: schoolInfo?.schoolName || user.school?.name,
      className: schoolInfo?.className || user.studentInfo?.class?.name,
    };
  }

  /**
   * Register a new user
   * POST /api/auth/register
   */
  async register(req: Request, res: Response, next: NextFunction) {
    try {
      const {
        email,
        password,
        roleName,
        baseUserInfo,
        specificInfo,
        schoolId,
        classId,
        schoolData,
      } = req.body;

      // Validate required fields
      if (!email || !password || !roleName || !baseUserInfo?.fullName) {
        return ResponseUtil.sendError(
          res,
          "Email, password, role, and full name are required",
          null,
          400
        );
      }

      // Validate email format
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        return ResponseUtil.sendError(res, "Invalid email format", null, 400);
      }

      // Validate password strength (minimum 6 characters)
      if (password.length < 6) {
        return ResponseUtil.sendError(
          res,
          "Password must be at least 6 characters long",
          null,
          400
        );
      }

      // Handle avatar file if uploaded
      let avatarFile: { buffer: Buffer; mimetype: string } | undefined;
      if (req.file) {
        avatarFile = {
          buffer: req.file.buffer,
          mimetype: req.file.mimetype,
        };
      }

      // Convert role name to RoleGroup enum
      let roleKey: RoleGroup;
      switch (roleName) {
        case "Student":
          roleKey = RoleGroup.Student;
          break;
        case "Teacher":
          roleKey = RoleGroup.Teacher;
          break;
        case "Staff":
          roleKey = RoleGroup.Staff;
          break;
        case "SchoolAdmin":
          roleKey = RoleGroup.SchoolAdmin;
          break;
        default:
          roleKey = RoleGroup.Staff;
      }

      // Execute use case
      const result = await registerUserUseCase.execute({
        email,
        password,
        fullName: baseUserInfo.fullName,
        roleKey,
        gender: baseUserInfo.gender,
        birthday: baseUserInfo.birthday
          ? new Date(baseUserInfo.birthday)
          : undefined,
        phone: baseUserInfo.phone,
        address: baseUserInfo.address,
        schoolId,
        classId,
        avatarFile,
        specificInfo,
        schoolData,
      });

      // Get user's school and class info for response
      // Wait for Sync Service to populate MongoDB (simple retry mechanism)
      let userSchoolInfo;
      let retries = 5;
      while (retries > 0) {
        try {
          userSchoolInfo = await userReadRepository.getUserSchoolInfo(
            result.user.id
          );
          if (userSchoolInfo) break;
        } catch (error) {
          console.warn(
            "Read DB unavailable or query failed (skipping extended info):",
            error
          );
          break; // Stop retrying if DB is down/unreachable
        }
        await new Promise((resolve) => setTimeout(resolve, 500)); // Wait 500ms
        retries--;
      }

      return ResponseUtil.sendSuccess(
        res,
        "User registered successfully",
        {
          user: this.buildUserResponse(
            result.user,
            userSchoolInfo || undefined
          ),
          tokens: {
            accessToken: result.tokens.accessToken,
            refreshToken: result.tokens.refreshToken,
          },
        },
        201
      );
    } catch (error) {
      console.error("Register error:", error);
      return ResponseUtil.sendError(res, "Registration failed", error, 400);
    }
  }

  /**
   * Login user
   * POST /api/auth/login
   */
  async login(req: Request, res: Response, next: NextFunction) {
    try {
      const loginDto: LoginDto = req.body;

      // Validate required fields
      if (!loginDto.email || !loginDto.password) {
        return ResponseUtil.sendError(
          res,
          "Email and password are required",
          null,
          400
        );
      }

      // Execute use case
      const result = await loginUseCase.execute({
        email: loginDto.email,
        password: loginDto.password,
      });

      // Get user's school and class info for response to be consistent
      let userSchoolInfo;
      try {
        userSchoolInfo = await userReadRepository.getUserSchoolInfo(
          result.user.id
        );
      } catch (e) {
        // Ignore if fails, just return base info
      }

      return ResponseUtil.sendSuccess(res, "Login successful", {
        user: this.buildUserResponse(result.user, userSchoolInfo || undefined),
        tokens: result.tokens,
      });
    } catch (error) {
      console.error("Login error:", error);
      return ResponseUtil.sendError(res, "Login failed", error, 401);
    }
  }

  /**
   * Refresh access token
   * POST /api/auth/refresh-token
   */
  async refreshToken(req: Request, res: Response, next: NextFunction) {
    try {
      const refreshTokenDto: RefreshTokenDto = req.body;

      // Validate required fields
      if (!refreshTokenDto.refreshToken) {
        return ResponseUtil.sendError(
          res,
          "Refresh token is required",
          null,
          400
        );
      }

      // Execute use case
      const result = await refreshAccessTokenUseCase.execute({
        refreshToken: refreshTokenDto.refreshToken,
      });

      return ResponseUtil.sendSuccess(res, "Token refreshed successfully", {
        tokens: {
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
        },
      });
    } catch (error) {
      console.error("Refresh token error:", error);
      return ResponseUtil.sendError(res, "Token refresh failed", error, 401);
    }
  }

  /**
   * Get authenticated user information
   * GET /api/auth/me
   */
  async getAuth(req: Request, res: Response, next: NextFunction) {
    try {
      // Extract token from Authorization header
      const authHeader = req.headers.authorization;
      const token = AuthUtils.extractBearerToken(authHeader);

      if (!token) {
        return ResponseUtil.sendError(res, "No token provided", null, 401);
      }

      // Execute use case
      const result = await getAuthUseCase.execute({
        accessToken: token,
      });

      // Try to get full user info from read database
      let fullUserInfo;
      try {
        fullUserInfo = await userReadRepository.getUserFullInfo(result.user.id);
      } catch (error) {
        console.warn("Could not fetch full user info from read DB:", error);
      }

      const userResponse = fullUserInfo
        ? this.buildUserResponse(fullUserInfo)
        : this.buildUserResponse(result.user);

      return ResponseUtil.sendSuccess(
        res,
        "User information retrieved successfully",
        {
          user: userResponse,
          account: {
            id: result.account.id,
            email: result.account.email,
            isActive: result.account.isActive,
            lastLogin: result.account.lastLogin,
          },
        }
      );
    } catch (error) {
      console.error("Get auth error:", error);
      return ResponseUtil.sendError(res, "Authentication failed", error, 401);
    }
  }
}
