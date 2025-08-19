import { DefaultLogger } from "../utils/DefaultLogger.js";
import StudentRepository from "../repositories/student.repository.js";
import { IStudent } from "../models";
class StudentService {
  private readonly logger: DefaultLogger;
  private readonly studentRepository: StudentRepository;

  constructor(
    studentRepository: StudentRepository,
    DefaultLogger: DefaultLogger
  ) {
    this.logger = DefaultLogger;
    this.studentRepository = studentRepository;
  }

  async getAllStudents(userId: string, userRole: string) {
    try {
      const students = await this.studentRepository.findAll();
      await this.logger.log({
        userId,
        action: "GET_ALL_STUDENTS",
        roleSnapshot: userRole,
        metadata: { count: students.length },
      });
      return students;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_ALL_STUDENTS_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getStudentById(id: string, userId: string, userRole: string) {
    try {
      const Student = await this.studentRepository.findById(id);
      if (!Student) {
        throw new Error(`Student with ID ${id} not found`);
      }
      await this.logger.log({
        userId,
        action: "GET_Student_BY_ID",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!Student },
      });
      return Student;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_Student_BY_ID_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createStudent(
    StudentData: Partial<IStudent>,
    userId: string,
    userRole: string
  ) {
    try {
      const studentData = await this.studentRepository.create(StudentData);

      await this.logger.log({
        userId,
        action: "POST_STUDENT",
        roleSnapshot: userRole,
        metadata: { found: !!studentData },
      });
      return studentData;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "POST_Student_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateStudent(
    id: string,
    StudentData: Partial<IStudent>,
    userId: string,
    userRole: string
  ) {
    try {
      const studentData = await this.studentRepository.update(id, StudentData);
      if (!studentData) {
        throw new Error(`Student with ID ${id} not found`);
      }
      await this.logger.log({
        userId,
        action: "UPDATE_STUDENT",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!studentData },
      });
      return studentData;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "UPDATE_STUDENT_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteStudent(id: string, userId: string, userRole: string) {
    try {
      const studentData = await this.studentRepository.delete(id);
      if (!studentData) {
        throw new Error(`Student with ID ${id} not found`);
      }
      await this.logger.log({
        userId,
        action: "DELETE_STUDENT",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!studentData },
      });
      return studentData;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "DELETE_STUDENT_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}
export default StudentService;
