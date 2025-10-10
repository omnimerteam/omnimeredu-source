import { Model } from "mongoose";
import { ITuition } from "../../../models";
import { BaseRepository } from "../.././base.repository";

class TuitionRepository extends BaseRepository<ITuition>{
    constructor(tuitionModel: Model<ITuition>){
        super(tuitionModel);
    }
}

export default TuitionRepository;