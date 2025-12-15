import { IRoleRepository } from "../../domain/repositories/IRoleRepository";
import { Role } from "../../domain/entities/Role";
import { RoleModel } from "../datasources/postgres/models/RoleModel";
import { RoleGroup } from "shared-lib";

export class RoleRepositoryImpl implements IRoleRepository {
  async findByGroup(group: RoleGroup): Promise<Role[]> {
    const roleModels = await RoleModel.findAll({ where: { group } });
    return roleModels.map((model) => this.toEntity(model));
  }

  async findOneByGroup(group: RoleGroup): Promise<Role | null> {
    const roleModel = await RoleModel.findOne({ where: { group } });
    if (!roleModel) return null;
    return this.toEntity(roleModel);
  }

  async findById(id: string): Promise<Role | null> {
    const roleModel = await RoleModel.findByPk(id);
    if (!roleModel) return null;
    return this.toEntity(roleModel);
  }

  async create(role: Role): Promise<Role> {
    const roleModel = await RoleModel.create({
      name: role.name,
      group: role.group,
      description: role.description,
      permissions: role.permissions,
    });
    return this.toEntity(roleModel);
  }

  private toEntity(model: RoleModel): Role {
    return new Role(
      model.id,
      model.name,
      model.group,
      model.description,
      model.permissions,
      model.createdAt,
      model.updatedAt
    );
  }
}
