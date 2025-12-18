import axios from "axios";

const USER_SERVICE_URL =
  process.env.USER_SERVICE_URL || "http://localhost:3001";

export interface StudentInfo {
  id: string;
  fullName: string;
  email?: string;
  avatar?: string;
  phone?: string;
  gender?: string;
  birthday?: string;
  guardianName?: string;
  guardianPhone?: string;
}

export interface ClassInfo {
  id: string;
  name: string;
  code: string;
}

export interface SchoolInfo {
  id: string;
  name: string;
  code: string;
}

/**
 * Client for communicating with User Service
 * Used for getting student information for attendance
 */
export class UserServiceClient {
  private baseUrl: string;

  constructor() {
    this.baseUrl = USER_SERVICE_URL;
  }

  /**
   * Get all students in a class by classId
   * @param classId - The class ID to get students for
   * @returns Array of student info with id and name
   */
  async getStudentsByClassId(classId: string): Promise<StudentInfo[]> {
    try {
      const response = await axios.get(
        `${this.baseUrl}/api/classes/internal/${classId}/students`
      );

      if (response.data.success && response.data.data) {
        // Map the response to StudentInfo format
        return response.data.data.map((student: any) => ({
          id: student._id || student.id,
          fullName: student.fullName || "Unknown",
          email: student.email,
          avatar: student.avatar,
          phone: student.phone,
          gender: student.gender,
          birthday: student.birthday,
          guardianName: student.student?.guardianName || "",
          guardianPhone: student.student?.guardianPhone || "",
        }));
      }

      return [];
    } catch (error: any) {
      console.error(
        `Failed to fetch students for class ${classId}:`,
        error.message
      );
      // Return empty array instead of throwing to allow graceful degradation
      return [];
    }
  }

  /**
   * Get class info by classId
   * @param classId - The class ID
   * @returns Class info with id, name, code
   */
  async getClassById(classId: string): Promise<ClassInfo | null> {
    try {
      const response = await axios.get(
        `${this.baseUrl}/api/classes/internal/${classId}`
      );

      if (response.data.success && response.data.data) {
        const classData = response.data.data;
        return {
          id: classData.id || classData._id,
          name: classData.name || "",
          code: classData.code || "",
        };
      }

      return null;
    } catch (error: any) {
      console.error(`Failed to fetch class ${classId}:`, error.message);
      return null;
    }
  }

  /**
   * Get school info by schoolId
   * @param schoolId - The school ID
   * @returns School info with id, name, code
   */
  async getSchoolById(schoolId: string): Promise<SchoolInfo | null> {
    try {
      const response = await axios.get(
        `${this.baseUrl}/api/schools/internal/${schoolId}`
      );

      if (response.data.success && response.data.data) {
        const schoolData = response.data.data;
        return {
          id: schoolData.id || schoolData._id,
          name: schoolData.name || "",
          code: schoolData.code || "",
        };
      }

      return null;
    } catch (error: any) {
      console.error(`Failed to fetch school ${schoolId}:`, error.message);
      return null;
    }
  }
}

// Singleton instance
export const userServiceClient = new UserServiceClient();
