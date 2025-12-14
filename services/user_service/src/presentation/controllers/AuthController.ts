import { Request, Response, NextFunction } from "express";
import { RegisterUserUseCase } from "../../domain/usecases/user/RegisterUserUseCase";
import { LoginUseCase } from "../../domain/usecases/user/LoginUseCase";
import { RefreshAccessTokenUseCase } from "../../domain/usecases/user/RefreshAccessTokenUseCase";
import { GetAuthUseCase } from "../../domain/usecases/user/GetAuthUseCase";
import { UserRepositoryImpl } from "../../data/repositories/UserRepositoryImpl";
import { UserReadRepositoryImpl } from "../../data/repositories/UserReadRepositoryImpl";
import { MembershipRequestRepositoryImpl } from "../../data/repositories/MembershipRequestRepositoryImpl";
import { AuthUtils } from "../../infrastructure/utils/AuthUtils";
import { RegisterDto, LoginDto, RefreshTokenDto } from "../dtos/AuthDto";
import { RoleGroup } from "shared-lib";

// Initialize repositories
// Initialize repositories
const userRepository = new UserRepositoryImpl();
const userReadRepository = new UserReadRepositoryImpl();
const membershipRequestRepository = new MembershipRequestRepositoryImpl();

// Initialize use cases
const registerUserUseCase = new RegisterUserUseCase(
  userRepository,
  membershipRequestRepository
);
const loginUseCase = new LoginUseCase(userRepository);
const refreshAccessTokenUseCase = new RefreshAccessTokenUseCase(userRepository);
const getAuthUseCase = new GetAuthUseCase(userRepository);

export class AuthController {
  /**
   * Register a new user
   * POST /api/auth/register
   */
  async register(req: Request, res: Response, next: NextFunction) {
    try {
      const { email, password, roleName, baseUserInfo, specificInfo, schoolId, classId, schoolData } = req.body;

      // Validate required fields
      if (!email || !password || !roleName || !baseUserInfo?.fullName) {
        return res.status(400).json({
          success: false,
          message: "Email, password, role, and full name are required",
        });
      }

      // Validate email format
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        return res.status(400).json({
          success: false,
          message: "Invalid email format",
        });
      }

      // Validate password strength (minimum 6 characters)
      if (password.length < 6) {
        return res.status(400).json({
          success: false,
          message: "Password must be at least 6 characters long",
        });
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
        case 'Student':
          roleKey = RoleGroup.Student;
          break;
        case 'Teacher':
          roleKey = RoleGroup.Teacher;
          break;
        case 'Staff':
          roleKey = RoleGroup.Staff;
          break;
        case 'SchoolAdmin':
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
      const userSchoolInfo = await userReadRepository.getUserSchoolInfo(result.user.id);

      return res.status(201).json({
        success: true,
        message: "User registered successfully",
        data: {
          user: {
            email: result.user.email,
            roleKey: result.user.roleKey,
            schoolName: userSchoolInfo?.schoolName,
            className: userSchoolInfo?.className,
          },
          accessToken: result.tokens.accessToken,
          refreshToken: result.tokens.refreshToken,
        },
      });
    } catch (error) {
      console.error("Register error:", error);
      return res.status(400).json({
        success: false,
        message: error instanceof Error ? error.message : "Registration failed",
      });
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
        return res.status(400).json({
          success: false,
          message: "Email and password are required",
        });
      }

      // Execute use case
      const result = await loginUseCase.execute({
        email: loginDto.email,
        password: loginDto.password,
      });

      return res.status(200).json({
        success: true,
        message: "Login successful",
        data: {
          user: {
            id: result.user.id,
            fullName: result.user.fullName,
            email: result.user.email,
            roleKey: result.user.roleKey,
            avatarUrl: result.user.avatarUrl,
            isVerified: result.user.isVerified,
            schoolId: result.user.schoolId,
          },
          tokens: result.tokens,
        },
      });
    } catch (error) {
      console.error("Login error:", error);
      return res.status(401).json({
        success: false,
        message: error instanceof Error ? error.message : "Login failed",
      });
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
        return res.status(400).json({
          success: false,
          message: "Refresh token is required",
        });
      }

      // Execute use case
      const result = await refreshAccessTokenUseCase.execute({
        refreshToken: refreshTokenDto.refreshToken,
      });

      return res.status(200).json({
        success: true,
        message: "Token refreshed successfully",
        data: {
          tokens: {
            accessToken: result.accessToken,
            refreshToken: result.refreshToken,
          },
        },
      });
    } catch (error) {
      console.error("Refresh token error:", error);
      return res.status(401).json({
        success: false,
        message:
          error instanceof Error ? error.message : "Token refresh failed",
      });
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
        return res.status(401).json({
          success: false,
          message: "No token provided",
        });
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

      return res.status(200).json({
        success: true,
        message: "User information retrieved successfully",
        data: {
          user: fullUserInfo || {
            id: result.user.id,
            fullName: result.user.fullName,
            email: result.user.email,
            roleKey: result.user.roleKey,
            avatarUrl: result.user.avatarUrl,
            isVerified: result.user.isVerified,
            schoolId: result.user.schoolId,
            gender: result.user.gender,
            birthday: result.user.birthday,
            phone: result.user.phone,
            address: result.user.address,
          },
          account: {
            id: result.account.id,
            email: result.account.email,
            uid: result.account.uid,
            isActive: result.account.isActive,
            lastLogin: result.account.lastLogin,
          },
        },
      });
    } catch (error) {
      console.error("Get auth error:", error);
      return res.status(401).json({
        success: false,
        message:
          error instanceof Error ? error.message : "Authentication failed",
      });
    }
  }
}
