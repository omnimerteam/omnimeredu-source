import { Role } from "../entities/Role";
import { RoleGroup } from "shared-lib";

export interface IRoleRepository {
  findByGroup(group: RoleGroup): Promise<Role[]>;
  findOneByGroup(group: RoleGroup): Promise<Role | null>;
  findById(id: string): Promise<Role | null>;
  create(role: Role): Promise<Role>;
}
