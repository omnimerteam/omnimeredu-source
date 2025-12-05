import { IMembershipRequestRepository } from "../../domain/repositories/IMembershipRequestRepository";
import { MembershipRequest } from "../../domain/entities/MembershipRequest";
import { MembershipRequestModel } from "../datasources/postgres/models/MembershipRequestModel";

export class MembershipRequestRepositoryImpl
  implements IMembershipRequestRepository
{
  async create(request: MembershipRequest): Promise<MembershipRequest> {
    const model = await MembershipRequestModel.create({
      userId: request.userId,
      schoolId: request.schoolId,
      classId: request.classId,
      role: request.role,
      action: request.action,
      status: request.status,
      note: request.note,
    });
    return this.toEntity(model);
  }

  async findById(id: string): Promise<MembershipRequest | null> {
    const model = await MembershipRequestModel.findByPk(id);
    if (!model) return null;
    return this.toEntity(model);
  }

  async findByUserId(userId: string): Promise<MembershipRequest[]> {
    const models = await MembershipRequestModel.findAll({ where: { userId } });
    return models.map((model) => this.toEntity(model));
  }

  async findBySchoolId(schoolId: string): Promise<MembershipRequest[]> {
    const models = await MembershipRequestModel.findAll({
      where: { schoolId },
    });
    return models.map((model) => this.toEntity(model));
  }

  async update(request: MembershipRequest): Promise<MembershipRequest> {
    const [affectedCount, updatedModels] = await MembershipRequestModel.update(
      {
        userId: request.userId,
        schoolId: request.schoolId,
        classId: request.classId,
        role: request.role,
        action: request.action,
        status: request.status,
        note: request.note,
      },
      {
        where: { id: request.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("MembershipRequest not found or not updated");
    }

    return this.toEntity(updatedModels[0]);
  }

  async delete(id: string): Promise<boolean> {
    const deletedCount = await MembershipRequestModel.destroy({
      where: { id },
    });
    return deletedCount > 0;
  }

  private toEntity(model: MembershipRequestModel): MembershipRequest {
    return new MembershipRequest(
      model.id,
      model.userId,
      model.schoolId,
      model.role,
      model.action,
      model.status,
      model.classId,
      model.note,
      model.createdAt,
      model.updatedAt
    );
  }
}
