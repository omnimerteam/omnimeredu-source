import { FilterQuery, Types } from "mongoose";

import { IClass } from "../../../models";

import { ClassRepository, StudentRepository } from "../../../repositories";
import { DefaultLogger } from "../../../../common/utils/DefaultLogger";

class ClassService {
  private readonly classRepository: ClassRepository;
  private readonly logger: DefaultLogger;
  private readonly studentRepository: StudentRepository;

  constructor(
    classRepository: ClassRepository,
    logger: DefaultLogger,
    studentRepository: StudentRepository
  ) {
    this.classRepository = classRepository;
    this.logger = logger;
    this.studentRepository = studentRepository;
  }

  async getAllClasses(
    actorId: string,
    userRole: string,
    schoolId?: string,
    options?: { page?: number; limit?: number; sort?: any }
  ) {
    try {
      let filter: any = {};

      if (userRole === "SuperAdmin") {
        filter = {}; // không giới hạn
      } else if (userRole === "SchoolAdmin") {
        if (!schoolId) throw new Error("Thiếu schoolId");
        filter = { schoolId };
      } else {
        throw new Error("Bạn không có quyền xem danh sách lớp");
      }

      const classes = await this.classRepository.findAll(filter, options);

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_CLASSES",
        roleSnapshot: userRole,
        metadata: {
          filter,
          options,
          count: classes.length,
        },
      });

      return classes;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_CLASSES_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getClassById(actorId: string, userRole: string, id: string) {
    try {
      const classData = await this.classRepository.findById(id);

      await this.logger.log({
        userId: actorId,
        action: "GET_CLASS_BY_ID",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!classData },
      });

      return classData;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_CLASS_BY_ID_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createClass(actorId: string, userRole: string, data: Partial<IClass>) {
    try {
      const created = await this.classRepository.create(data);

      await this.logger.log({
        userId: actorId,
        action: "CREATE_CLASS",
        targetId: created._id.toString(),
        roleSnapshot: userRole,
        metadata: { name: created.name, code: created.code },
      });

      return created;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "CREATE_CLASS_FAILED",
        roleSnapshot: userRole,
        metadata: {
          input: data,
          error: (error as Error).message,
        },
      });
      throw error;
    }
  }

  async updateClass(
    actorId: string,
    userRole: string,
    id: string,
    data: Partial<IClass>
  ) {
    try {
      const updated = await this.classRepository.update(id, data);

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_CLASS",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { updated },
      });

      return updated;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_CLASS_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: {
          input: data,
          error: (error as Error).message,
        },
      });
      throw error;
    }
  }

  async deleteClass(actorId: string, userRole: string, id: string) {
    try {
      const deleted = await this.classRepository.delete(id);

      await this.logger.log({
        userId: actorId,
        action: "DELETE_CLASS",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { success: deleted },
      });

      return deleted;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_CLASS_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  /**
   *
   * @param actorId
   * @param userRole
   * @param filter
   * @param options
   * @returns danh sách phù hơp với filter
   */
  async searchClass(
    actorId: string,
    userRole: string,
    filter: FilterQuery<IClass> = {},
    options?: { page?: number; limit?: number; sort?: any }
  ) {
    try {
      const result = await this.classRepository.findAll(filter, options);

      await this.logger.log({
        userId: actorId,
        action: "SEARCH_CLASS",
        roleSnapshot: userRole,
        metadata: {
          filter,
          options,
          resultCount: result.length,
        },
      });

      return result;
    } catch (err) {
      await this.logger.log({
        userId: actorId,
        action: "SEARCH_CLASS_FAILED",
        roleSnapshot: userRole,
        metadata: {
          filter,
          options,
          error: (err as Error).message,
        },
      });

      throw err;
    }
  }

  /**
   * Thêm học sinh vào lớp học
   * @param actorId
   * @param userRole
   * @param classId
   * @param studentIds
   * @returns {
   * "addedCount": 2,
   * "failedCount": 2,
   * "failed": [
   *       {
   *        "studentId": "abc123",
   *       "reason": "Học sinh đã thuộc lớp khác"
   *    },
   *   {
   *     "studentId": "def456",
   *    "reason": "Học sinh thuộc trường khác"
   * }
   *]
   *}
   */
  async addStudentToClass(
    actorId: string,
    userRole: string,
    classId: string,
    studentIds: string[]
  ) {
    try {
      const classData = await this.classRepository.findById(classId);
      if (!classData) {
        throw new Error("Lớp học không tồn tại");
      }

      const failedStudents: { studentId: string; reason: string }[] = [];
      const validStudents: string[] = [];

      for (const studentId of studentIds) {
        const student = await this.studentRepository.findById(studentId);
        if (!student) {
          failedStudents.push({ studentId, reason: "Không tìm thấy học sinh" });
          continue;
        }

        // Kiểm tra schoolId
        if (student.schoolId?.toString() !== classData.schoolId.toString()) {
          failedStudents.push({
            studentId,
            reason: "Học sinh thuộc trường khác",
          });
          continue;
        }

        // Kiểm tra classId
        if (student.classId) {
          failedStudents.push({
            studentId,
            reason: "Học sinh đã thuộc lớp khác",
          });
          continue;
        }

        validStudents.push(studentId);
      }

      // Cập nhật class
      if (validStudents.length > 0) {
        await this.classRepository.addStudentsToClass(classId, validStudents);
        await this.studentRepository.assignClassToStudents(
          validStudents,
          classId
        );
      }

      // Ghi log thành công
      await this.logger.log({
        userId: actorId,
        action: "ADD_STUDENT_TO_CLASS",
        roleSnapshot: userRole,
        metadata: {
          classId,
          addedCount: validStudents.length,
          failedCount: failedStudents.length,
          failedStudents,
        },
      });

      return {
        addedCount: validStudents.length,
        failedCount: failedStudents.length,
        failed: failedStudents,
      };
    } catch (err) {
      // Ghi log lỗi
      await this.logger.log({
        userId: actorId,
        action: "ADD_STUDENT_TO_CLASS_FAILED",
        roleSnapshot: userRole,
        metadata: {
          classId,
          studentIds,
          error: (err as Error).message,
        },
      });

      throw err;
    }
  }

  /**
   * Xóa danh sách học sinh khỏi lớp học
   * @param actorId
   * @param userRole
   * @param classId
   * @param studentIds
   * @returns {
   * "removed": 2
   * }
   */
  async removeStudentFromClass(
    actorId: string,
    userRole: string,
    classId: string,
    studentIds: string[]
  ) {
    try {
      const classData = await this.classRepository.findById(classId);
      if (!classData) {
        throw new Error("Lớp học không tồn tại");
      }

      // Lọc ra những student hiện đang trong lớp này
      const studentsToRemoveObjectIds: Types.ObjectId[] =
        classData.students.filter((id) => studentIds.includes(id.toString()));

      const studentsToRemove: string[] = studentsToRemoveObjectIds.map((id) =>
        id.toString()
      );

      if (studentsToRemove.length === 0) {
        throw new Error("Không có học sinh nào thuộc lớp này để xóa");
      }

      // Gọi repository để cập nhật
      await this.classRepository.removeStudentsFromClass(
        classId,
        studentsToRemove
      );
      await this.studentRepository.clearClassIdForStudents(studentsToRemove);

      // Ghi log thành công
      await this.logger.log({
        userId: actorId,
        action: "REMOVE_STUDENT_FROM_CLASS",
        roleSnapshot: userRole,
        metadata: {
          classId,
          removedStudents: studentsToRemove,
        },
      });

      return {
        removed: studentsToRemove.length,
      };
    } catch (err) {
      // Ghi log thất bại
      await this.logger.log({
        userId: actorId,
        action: "REMOVE_STUDENT_FROM_CLASS_FAILED",
        roleSnapshot: userRole,
        metadata: {
          classId,
          studentIds,
          error: (err as Error).message,
        },
      });

      throw err;
    }
  }

  /**
   * Chuyển học sinh sang lớp khác
   * @param actorId
   * @param userRole
   * @param toClassId
   * @param studentIds
   * @returns {
   * "transferred": 2,
   * "failedCount": 2,
   * "failed": [
   *    { studentId: "1", reason: "Không tìm thấy học sinh" },
   *    { studentId: "2", reason: "Học sinh chưa thuộc lớp nào" }
   * ]
   * }
   */
  async transferClass(
    actorId: string,
    userRole: string,
    toClassId: string,
    studentIds: string[]
  ) {
    try {
      const targetClass = await this.classRepository.findById(toClassId);
      if (!targetClass) {
        throw new Error("Lớp học đích không tồn tại");
      }

      const failed: { studentId: string; reason: string }[] = [];
      const validTransfers: { studentId: string; fromClassId: string }[] = [];

      for (const studentId of studentIds) {
        const student = await this.studentRepository.findById(studentId);
        if (!student) {
          failed.push({ studentId, reason: "Không tìm thấy học sinh" });
          continue;
        }

        if (!student.classId) {
          failed.push({ studentId, reason: "Học sinh chưa thuộc lớp nào" });
          continue;
        }

        if (student.classId.toString() === toClassId) {
          failed.push({ studentId, reason: "Học sinh đã thuộc lớp đích" });
          continue;
        }

        validTransfers.push({
          studentId,
          fromClassId: student.classId.toString(),
        });
      }

      if (validTransfers.length > 0) {
        const studentIdsToTransfer = validTransfers.map((s) => s.studentId);

        // 1. Cập nhật lớp cũ: remove students
        const classIdsToPullFrom = [
          ...new Set(validTransfers.map((s) => s.fromClassId)),
        ];
        for (const classId of classIdsToPullFrom) {
          const studentsInThisClass = validTransfers
            .filter((s) => s.fromClassId === classId)
            .map((s) => s.studentId);
          await this.classRepository.removeStudentsFromClass(
            classId,
            studentsInThisClass
          );
        }

        // 2. Cập nhật lớp mới: add students
        await this.classRepository.addStudentsToClass(
          toClassId,
          studentIdsToTransfer
        );

        // 3. Cập nhật student.classId
        await this.studentRepository.assignClassToStudents(
          studentIdsToTransfer,
          toClassId
        );
      }

      await this.logger.log({
        userId: actorId,
        action: "TRANSFER_CLASS",
        roleSnapshot: userRole,
        metadata: {
          toClassId,
          transferred: validTransfers,
          failed,
        },
      });

      return {
        transferred: validTransfers.length,
        failedCount: failed.length,
        failed,
      };
    } catch (err) {
      await this.logger.log({
        userId: actorId,
        action: "TRANSFER_CLASS_FAILED",
        roleSnapshot: userRole,
        metadata: {
          toClassId,
          studentIds,
          error: (err as Error).message,
        },
      });

      throw err;
    }
  }
}

export default ClassService;
