import { DefaultLogger } from "../../../common/utils/DefaultLogger.js";
import {
  ClassRepository,
  RoleRepository,
  StudentRepository,
} from "../../repositories";
import { IStudent } from "../../models";
import { PaginationQueryOptions } from "../../../common/utils/buildQueryOptions";
import {
  buildPermissionFilterForClass,
  buildPermissionFilterForStudent,
} from "../../../common/utils/permissionFilter";
import { HttpError } from "../../../common/utils/HttpError";
import { RoleEnum } from "../../../common/enum/role.enum";
class StudentService {
  private readonly logger: DefaultLogger;
  private readonly studentRepository: StudentRepository;
  private readonly roleRepository: RoleRepository;
  private readonly classRepository: ClassRepository;

  constructor(
    studentRepository: StudentRepository,
    roleRepository: RoleRepository,
    classRepository: ClassRepository,
    DefaultLogger: DefaultLogger
  ) {
    this.logger = DefaultLogger;
    this.roleRepository = roleRepository;
    this.studentRepository = studentRepository;
    this.classRepository = classRepository;
  }

  async getAllStudents(
    actorId: string,
    userRole: string,
    schoolId?: string,
    options?: PaginationQueryOptions
  ) {
    try {
      const filter = buildPermissionFilterForStudent(userRole, schoolId);

      const students = await this.studentRepository.findAllStudent(
        filter,
        options
      );

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

  async getStudentSelector(
    actorId: string,
    userRole: string,
    schoolId?: string,
    gradeId?: string
  ) {
    try {
      const filter = buildPermissionFilterForStudent(userRole, schoolId);

      const students = await this.studentRepository.getStudentSelector(
        gradeId,
        filter.schoolId
      );

      await this.logger.log({
        userId: actorId,
        action: "GET_STUDENT_SELECTOR",
        roleSnapshot: userRole,
        metadata: {
          filter: { gradeId, filter },
          count: students.length,
        },
      });

      return students;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_STUDENT_SELECTOR_FAILED",
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
        throw new HttpError(400, `Student with ID ${id} not found`);
      }
      await this.logger.log({
        userId: actorId,
        action: "GET_STUDENT_BY_ID",
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
      if (!studentData.roleId) {
        const studentRole = await this.roleRepository.findByRoleName(
          RoleEnum.Student
        );

        if (!studentRole) {
          throw new HttpError(500, "Vai trò này không thuộc hệ thống");
        }

        studentData.roleId = studentRole._id;
      }

      const newStudent = await this.studentRepository.create(studentData);
      await this.classRepository.addStudentsToClass(
        studentData.classId!.toString(),
        [newStudent._id.toString()]
      );

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
      // Lấy thông tin hiện tại của học sinh
      const existingStudent = await this.studentRepository.findById(id);
      if (!existingStudent) {
        throw new Error(`Student with ID ${id} not found`);
      }

      const oldClassId = existingStudent.classId?.toString();
      const newClassId = studentData.classId?.toString();

      // Cập nhật thông tin học sinh (bỏ qua classId nếu undefined)
      const { classId, ...otherData } = studentData;
      const updatedStudent = await this.studentRepository.update(id, {
        ...otherData,
        ...(newClassId ? { classId: newClassId } : {}),
      });

      // Nếu không có bản ghi nào được cập nhật → throw lỗi
      if (!updatedStudent) {
        throw new HttpError(400, " Cập nhật dữ liệu thấ bại");
      }

      // Nếu có classId mới thì mới xử lý cập nhật lớp
      if (newClassId && newClassId !== oldClassId) {
        // Thêm học sinh vào lớp mới
        await this.classRepository.addStudentsToClass(newClassId, [
          updatedStudent._id.toString(),
        ]);

        // Gỡ học sinh khỏi lớp cũ nếu có
        if (oldClassId) {
          await this.classRepository.removeStudentsFromClass(oldClassId, [
            updatedStudent._id.toString(),
          ]);
        }
      }

      // Log hành động thành công
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_STUDENT",
        targetId: id,
        roleSnapshot: userRole,
        metadata: {
          found: !!updatedStudent,
          classChanged: !!(newClassId && newClassId !== oldClassId),
        },
      });

      return updatedStudent;
    } catch (error) {
      // Log thất bại
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
      const oldClassId = (await this.studentRepository.findById(id))?.classId;
      const deletedStudent = await this.studentRepository.delete(id);

      await this.classRepository.removeStudentsFromClass(
        oldClassId!.toString(),
        [id.toString()]
      );

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
