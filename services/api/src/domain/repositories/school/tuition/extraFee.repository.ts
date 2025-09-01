import {Model} from "mongoose";
import { IExtraFee } from "../../../models";
import { BaseRepository } from "../../base.repository";

class ExtraFeeRepository extends BaseRepository<IExtraFee>{
    constructor(extraFeeModel: Model<IExtraFee>){
        super(extraFeeModel);
    }
}

export default ExtraFeeRepository;