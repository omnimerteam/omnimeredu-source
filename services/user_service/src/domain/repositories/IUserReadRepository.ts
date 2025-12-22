/**
 * Interface for User Read Repository (MongoDB)
 * Handles read operations with denormalized data
 */
export interface IUserReadRepository {
  /**
   * Get full user information by user ID
   * @param userId - User ID
   * @returns Full user information with all joined data
   */
  getUserFullInfo(userId: string): Promise<any>;

  /**
   * Get user full information by email
   * @param email - User email
   * @returns Full user information with all joined data
   */
  getUserFullInfoByEmail(email: string): Promise<any>;

  /**
   * Get all users by school ID
   * @param schoolId - School ID
   * @returns Array of users with full information
   */
  getUsersBySchoolId(schoolId: string): Promise<any[]>;

  /**
   * Get all students by class ID
   * @param classId - Class ID
   * @returns Array of students with full information
   */
  getStudentsByClassId(classId: string): Promise<any[]>;

  /**
   * Get all teachers by class ID
   * @param classId - Class ID
   * @returns Array of teachers with full information
   */
  getTeachersByClassId(classId: string): Promise<any[]>;

  /**
   * Get users by role key
   * @param roleKey - Role key
   * @returns Array of users with full information
   */
  getUsersByRoleKey(roleKey: string): Promise<any[]>;
}
