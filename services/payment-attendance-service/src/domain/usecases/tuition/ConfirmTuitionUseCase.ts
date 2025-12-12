import { ITuitionRepository } from "../../repositories/ITuitionRepository";
import { ConfirmTuitionDto } from "../../../presentation/dtos/TuitionDto";
import { Tuition } from "../../entities/Tuition";

export class ConfirmTuitionUseCase {
    constructor(private tuitionRepository: ITuitionRepository) { }

    async execute(id: string, dto: ConfirmTuitionDto): Promise<Tuition> {
        const tuition = await this.tuitionRepository.findById(id);
        if (!tuition) {
            throw new Error("Tuition not found");
        }

        if (tuition.status !== "Draft") {
            throw new Error("Only Draft tuition can be confirmed");
        }

        tuition.status = "Pending";
        tuition.confirmedBy = dto.confirmedBy;
        tuition.confirmedAt = new Date();

        return await this.tuitionRepository.update(tuition);
    }
}
