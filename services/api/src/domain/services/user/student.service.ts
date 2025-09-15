import { DefaultLogger } from "../../../common/utils/DefaultLogger.js";
import { StudentRepository } from "../../repositories";
import { IStudent } from "../../models";
import { PaginationQueryOptions } from "../../../common/utils/buildQueryOptions";
import { buildPermissionFilter } from "../../../common/utils/permissionFilter";
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

  async getAllStudents(
    actorId: string,
    userRole: string,
    schoolId?: string,
    options?: PaginationQueryOptions
  ) {
    try {
      const filter = buildPermissionFilter(userRole, schoolId);

      const students = await this.studentRepository.findAll(filter, options);

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_STUDENTS",
        roleSnapshot: userRole,
        metadata: { options, filter, count: students.length },
      });

      return students;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_STUDENTS_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getStudentById(id: string, actorId: string, userRole: string) {
    try {
      const student = await this.studentRepository.findById(id);
      if (!student) {
        throw new Error(`Student with ID ${id} not found`);
      }
      await this.logger.log({
        userId: actorId,
        action: "GET_Student_BY_ID",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!student },
      });
      return student;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_STUDENT_BY_ID_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createStudent(
    studentData: Partial<IStudent>,
    actorId: string,
    userRole: string
  ) {
    try {
      const newStudent = await this.studentRepository.create(studentData);

      await this.logger.log({
        userId: actorId,
        action: "POST_STUDENT",
        roleSnapshot: userRole,
        metadata: { found: !!newStudent },
      });
      return newStudent;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "POST_STUDENT_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateStudent(
    id: string,
    studentData: Partial<IStudent>,
    actorId: string,
    userRole: string
  ) {
    try {
      const updatedStudent = await this.studentRepository.update(
        id,
        studentData
      );
      if (!updatedStudent) {
        throw new Error(`Student with ID ${id} not found`);
      }
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_STUDENT",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!updatedStudent },
      });
      return updatedStudent;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_STUDENT_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteStudent(id: string, actorId: string, userRole: string) {
    try {
      const deletedStudent = await this.studentRepository.delete(id);
      if (!deletedStudent) {
        throw new Error(`Student with ID ${id} not found`);
      }
      await this.logger.log({
        userId: actorId,
        action: "DELETE_STUDENT",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!deletedStudent },
      });
      return deletedStudent;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
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
