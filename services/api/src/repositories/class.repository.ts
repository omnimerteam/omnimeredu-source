import { Model, Types } from "mongoose";
import ClassModel, { IClass } from "../models/Class";

export class ClassRepository {
  private readonly model: Model<IClass>;

  constructor() {
    this.model = ClassModel;
  }

  async createClass(data: {
    name: string;
    code: string;
    schoolId: Types.ObjectId;
    teacherId?: Types.ObjectId;
    students?: Types.ObjectId[];
    baseFee: number;
  }): Promise<IClass | { error: string }> {
    try {
      const newClass = new this.model(data);
      return await newClass.save();
    } catch (error: any) {
      return { error: error.message };
    }
  }
}
