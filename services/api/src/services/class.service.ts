import { IClass } from "../models/Class";
import ClassRepository from "../repositories/class.repository";
import { ILogger } from "../interfaces/logger.interface";

class ClassService {
  private readonly classRepository: ClassRepository;
  private readonly logger: ILogger;

  constructor(classRepository: ClassRepository, logger: ILogger) {
    this.classRepository = classRepository;
    this.logger = logger;
  }

  async getAllClasses(userId: string, userRole: string) {
    try {
      const classes = await this.classRepository.findAll();

      await this.logger.log({
        userId,
        action: "GET_ALL_CLASSES",
        roleSnapshot: userRole,
        metadata: { count: classes.length },
      });

      return classes;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_ALL_CLASSES_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getClassById(userId: string, userRole: string, id: string) {
    try {
      const classData = await this.classRepository.findById(id);

      await this.logger.log({
        userId,
        action: "GET_CLASS_BY_ID",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!classData },
      });

      return classData;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_CLASS_BY_ID_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createClass(userId: string, userRole: string, data: Partial<IClass>) {
    try {
      const created = await this.classRepository.create(data);

      await this.logger.log({
        userId,
        action: "CREATE_CLASS",
        targetId: created._id.toString(),
        roleSnapshot: userRole,
        metadata: { name: created.name, code: created.code },
      });

      return created;
    } catch (error) {
      await this.logger.log({
        userId,
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
    userId: string,
    userRole: string,
    id: string,
    data: Partial<IClass>
  ) {
    try {
      const updated = await this.classRepository.update(id, data);

      await this.logger.log({
        userId,
        action: "UPDATE_CLASS",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { updated },
      });

      return updated;
    } catch (error) {
      await this.logger.log({
        userId,
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

  async deleteClass(userId: string, userRole: string, id: string) {
    try {
      const deleted = await this.classRepository.delete(id);

      await this.logger.log({
        userId,
        action: "DELETE_CLASS",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { success: deleted },
      });

      return deleted;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "DELETE_CLASS_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default ClassService;
