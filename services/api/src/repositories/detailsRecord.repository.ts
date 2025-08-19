import { Model, Document } from "mongoose";
import { BaseRepository } from "./base.repository";
import { IDetailsRecord } from "../models/school/attendance/DetailsRecord";

class DetailsRecordRepository extends BaseRepository<IDetailsRecord> {
  constructor(DetailsRecordModel: Model<IDetailsRecord>) {
    super(DetailsRecordModel);
  }
}
export default DetailsRecordRepository;
