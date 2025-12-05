import { registerSyncHooks } from "shared-lib";
import { noSQLClient } from "./mongodb/client";
import { SyncService } from "../messaging/SyncService";

// Import Models
import { UserModel } from "./postgres/models/UserModel";
import { SchoolModel } from "./postgres/models/SchoolModel";
import { GradeModel } from "./postgres/models/GradeModel";
import { ClassModel } from "./postgres/models/ClassModel";
import { MembershipRequestModel } from "./postgres/models/MembershipRequestModel";
import { RoleModel } from "./postgres/models/RoleModel";
import { SchoolAdminModel } from "./postgres/models/SchoolAdminModel";
import { SuperAdminModel } from "./postgres/models/SuperAdminModel";
import { TeacherModel } from "./postgres/models/TeacherModel";

const syncService = new SyncService(noSQLClient);

export const setupSyncHooks = () => {
  registerSyncHooks(UserModel, syncService, "users");
  registerSyncHooks(SchoolModel, syncService, "schools");
  registerSyncHooks(GradeModel, syncService, "grades");
  registerSyncHooks(ClassModel, syncService, "classes");
  registerSyncHooks(MembershipRequestModel, syncService, "membership_requests");
  registerSyncHooks(RoleModel, syncService, "roles");
  // Note: SchoolAdmin, SuperAdmin, Teacher are discriminators of User in Mongo,
  // but in Postgres they are separate tables.
  // If we want to sync them to the 'users' collection as discriminators,
  // we might need a more complex sync logic or just sync them to separate collections for now if the Read Schema expects that.
  // However, the Read Schemas I created for them are discriminators of UserReadModel.
  // So when we create a Teacher in Postgres, we want to update the corresponding User document in Mongo with teacher fields?
  // OR we treat them as separate documents?
  // The current simple SyncService just takes the data and puts it in a collection.
  // If we want to support discriminators, we might need to sync to 'users' collection but merge data?
  // For simplicity in this phase, let's sync them to 'users' collection but we need to handle the ID collision or update logic.
  // Actually, the simple sync overwrites or creates.
  // If we want to use Mongoose discriminators effectively, we should probably just update the User document.
  // But wait, the Postgres models (TeacherModel) only have specific fields, not the full User fields.
  // So if we sync TeacherModel to 'users', we might overwrite the User data with just teacher data if we are not careful.
  // A better approach for now might be to sync them to separate collections OR improve SyncService to handle partial updates / merges.
  // Given the constraints, I will comment them out or sync to separate collections if needed, but since they are discriminators in Mongo,
  // they technically live in the 'users' collection.
  // Let's assume for now we might need a custom sync for these or just skip auto-sync for them until SyncService is enhanced.
  // BUT, the user asked to "bổ sung thêm các model, schema".
  // I will register them but maybe to a separate logical collection name if that helps, or just leave them be for now.
  // Actually, if I look at `SchoolAdminReadModel`, it is `UserReadModel.discriminator`.
  // So it saves to `users` collection.
  // If I sync `TeacherModel` (which has `userId`, `qualification`...) to `users` collection,
  // and use `id` as key... wait, `TeacherModel` ID is different from `UserModel` ID (it's a separate PK).
  // So it would create a NEW document in `users` collection with the Teacher's ID. This is wrong.
  // The Teacher document in Mongo should probably share the User ID or be embedded.
  // In the reference `Teacher.ts` (Mongoose), it extends `BaseUser`.
  // So in Mongo, a Teacher IS a User.
  // In Postgres, we normalized it: User + Teacher (profile).
  // To sync correctly: When User is created -> Sync to Mongo (User fields).
  // When Teacher profile is created -> Update Mongo User document with Teacher fields?
  // This requires a custom Sync operation (Partial Update based on userId).
  // The current `SyncService` uses `id` to match.
  // `TeacherModel` has `userId`.
  // So we should probably not register simple sync hooks for these profile models yet, or we need to customize the hook to use `userId` as the key and do an UPDATE.
  // I will register RoleModel as it is independent.
  // For the others, I will leave a comment.

  registerSyncHooks(RoleModel, syncService, "roles");
};
