import { Model } from "mongoose";
import { IDiscountPolicy } from "../../../models/school/tuition/DiscountPolicy";
import { BaseRepository } from "../../base.repository";

class DiscountPolicyRepository extends BaseRepository<IDiscountPolicy> {
    constructor (discountPolicyModel: Model<IDiscountPolicy>){
        super(discountPolicyModel);
    }
}

export default DiscountPolicyRepository;