export interface RegisterDto {
  email: string;
  password: string;
  fullName: string;
  roleKey: string;
  gender?: string;
  birthday?: string; // ISO date string
  phone?: string;
  address?: string;
  schoolId?: string;
  specificInfo?: any;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface RefreshTokenDto {
  refreshToken: string;
}

export interface UploadAvatarDto {
  userId: string;
}
