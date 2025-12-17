import { ClassRepositoryImpl } from "../../../data/repositories/ClassRepositoryImpl";
import { StudentRepositoryImpl } from "../../../data/repositories/StudentRepositoryImpl";

export interface StudentOperationRequest {
  classId: string;
  studentIds: string[];
}

export interface TransferStudentsRequest {
  fromClassId: string;
  toClassId: string;
  studentIds: string[];
}

export class ManageStudentsUseCase {
  constructor(
    private classRepository: ClassRepositoryImpl,
    private studentRepository: StudentRepositoryImpl
  ) {}

  async addStudentsToClass(request: StudentOperationRequest): Promise<void> {
    const { classId, studentIds } = request;

    // Check if class exists
    const classExists = await this.classRepository.findById(classId);
    if (!classExists) {
      throw new Error("Class not found");
    }

    // Check if students exist and are not already in this class
    for (const studentId of studentIds) {
      const student = await this.studentRepository.findById(studentId);
      if (!student) {
        throw new Error(`Student with ID ${studentId} not found`);
      }

      // Check if student is already in this class
      if (student.classId === classId) {
        throw new Error(`Student ${studentId} is already in this class`);
      }
    }

    // Add students to class
    await this.studentRepository.updateClassForStudents(studentIds, classId);
  }

  async removeStudentsFromClass(request: StudentOperationRequest): Promise<void> {
    const { classId, studentIds } = request;

    // Check if class exists
    const classExists = await this.classRepository.findById(classId);
    if (!classExists) {
      throw new Error("Class not found");
    }

    // Check if students are in this class
    for (const studentId of studentIds) {
      const student = await this.studentRepository.findById(studentId);
      if (!student) {
        throw new Error(`Student with ID ${studentId} not found`);
      }

      if (student.classId !== classId) {
        throw new Error(`Student ${studentId} is not in this class`);
      }
    }

    // Remove students from class (set classId to null or empty)
    await this.studentRepository.updateClassForStudents(studentIds, null);
  }

  async transferStudentsBetweenClasses(request: TransferStudentsRequest): Promise<void> {
    const { fromClassId, toClassId, studentIds } = request;

    // Check if both classes exist
    const [fromClass, toClass] = await Promise.all([
      this.classRepository.findById(fromClassId),
      this.classRepository.findById(toClassId)
    ]);

    if (!fromClass) {
      throw new Error("Source class not found");
    }
    if (!toClass) {
      throw new Error("Target class not found");
    }

    // Check if students are in the source class
    for (const studentId of studentIds) {
      const student = await this.studentRepository.findById(studentId);
      if (!student) {
        throw new Error(`Student with ID ${studentId} not found`);
      }

      if (student.classId !== fromClassId) {
        throw new Error(`Student ${studentId} is not in the source class`);
      }
    }

    // Check if target class has capacity
    const currentStudentsInTarget = await this.studentRepository.countStudentsInClass(toClassId);
    const newStudentsCount = currentStudentsInTarget + studentIds.length;

    if (toClass.maxStudents && newStudentsCount > toClass.maxStudents) {
      throw new Error(`Target class cannot accept more than ${toClass.maxStudents} students`);
    }

    // Transfer students
    await this.studentRepository.updateClassForStudents(studentIds, toClassId);
  }
}