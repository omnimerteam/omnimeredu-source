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

  async getAllClasses(userId: string) {
    try {
      const classes = await this.classRepository.findAll();

      await this.logger.log({
        userId,
        action: "GET_ALL_CLASSES",
        roleSnapshot: "admin",
        metadata: { count: classes.length },
      });

      return classes;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_ALL_CLASSES_FAILED",
        roleSnapshot: "admin",
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getClassById(userId: string, id: string) {
    try {
      const classData = await this.classRepository.findById(id);

      await this.logger.log({
        userId,
        action: "GET_CLASS_BY_ID",
        targetId: id,
        roleSnapshot: "admin",
        metadata: { found: !!classData },
      });

      return classData;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_CLASS_BY_ID_FAILED",
        targetId: id,
        roleSnapshot: "admin",
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createClass(userId: string, data: Partial<IClass>) {
    try {
      const created = await this.classRepository.create(data);

      await this.logger.log({
        userId,
        action: "CREATE_CLASS",
        targetId: created._id.toString(),
        roleSnapshot: "admin",
        metadata: { name: created.name, code: created.code },
      });

      return created;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "CREATE_CLASS_FAILED",
        roleSnapshot: "admin",
        metadata: {
          input: data,
          error: (error as Error).message,
        },
      });
      throw error;
    }
  }

  async updateClass(userId: string, id: string, data: Partial<IClass>) {
    try {
      const updated = await this.classRepository.update(id, data);

      await this.logger.log({
        userId,
        action: "UPDATE_CLASS",
        targetId: id,
        roleSnapshot: "admin",
        metadata: { updated },
      });

      return updated;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "UPDATE_CLASS_FAILED",
        targetId: id,
        roleSnapshot: "admin",
        metadata: {
          input: data,
          error: (error as Error).message,
        },
      });
      throw error;
    }
  }

  async deleteClass(userId: string, id: string) {
    try {
      const deleted = await this.classRepository.delete(id);

      await this.logger.log({
        userId,
        action: "DELETE_CLASS",
        targetId: id,
        roleSnapshot: "admin",
        metadata: { success: deleted },
      });

      return deleted;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "DELETE_CLASS_FAILED",
        targetId: id,
        roleSnapshot: "admin",
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default ClassService;
