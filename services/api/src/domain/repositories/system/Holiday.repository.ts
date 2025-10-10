import { Model } from "mongoose";
import { BaseRepository } from "../base.repository";
import { IHoliday } from "../../models/system/Holiday";

class HolidayRepository extends BaseRepository<IHoliday>{
    constructor(HolidayModel: Model<IHoliday>){
        super(HolidayModel);
    }
}

export default HolidayRepository;