import { connectPostgres } from "shared-lib";
import dotenv from "dotenv";
import { initUserModel, UserModel } from "./models/UserModel";
import { initAccountModel, AccountModel } from "./models/AccountModel";
import { initStudentModel, StudentModel } from "./models/StudentModel";
import { initSchoolModel, SchoolModel } from "./models/SchoolModel";
import { initGradeModel, GradeModel } from "./models/GradeModel";
import { initClassModel, ClassModel } from "./models/ClassModel";
import {
  initMembershipRequestModel,
  MembershipRequestModel,
} from "./models/MembershipRequestModel";
import { initRoleModel, RoleModel } from "./models/RoleModel";
import {
  initSchoolAdminModel,
  SchoolAdminModel,
} from "./models/SchoolAdminModel";
import { initSuperAdminModel, SuperAdminModel } from "./models/SuperAdminModel";
import { initTeacherModel, TeacherModel } from "./models/TeacherModel";

dotenv.config();

const dbName = process.env.DB_NAME || "auth_service_db";
const dbUser = process.env.DB_USER || "postgres";
const dbPass = process.env.DB_PASS || "password";
const dbHost = process.env.DB_HOST || "localhost";
const dbPort = process.env.DB_PORT || "5432";

const uri =
  process.env.DATABASE_URL ||
  `postgres://${dbUser}:${dbPass}@${dbHost}:${dbPort}/${dbName}`;

export const sequelize = connectPostgres(uri);

// Initialize Models
initUserModel(sequelize);
initAccountModel(sequelize);
initStudentModel(sequelize);
initSchoolModel(sequelize);
initGradeModel(sequelize);
initClassModel(sequelize);
initMembershipRequestModel(sequelize);
initRoleModel(sequelize);
initSchoolAdminModel(sequelize);
initSuperAdminModel(sequelize);
initTeacherModel(sequelize);

// Define Associations

// User & Account
UserModel.hasOne(AccountModel, { foreignKey: "userId", as: "account" });
AccountModel.belongsTo(UserModel, { foreignKey: "userId", as: "user" });

// User & Student
UserModel.hasOne(StudentModel, { foreignKey: "userId", as: "studentProfile" });
StudentModel.belongsTo(UserModel, { foreignKey: "userId", as: "user" });

// User & SchoolAdmin
UserModel.hasOne(SchoolAdminModel, {
  foreignKey: "userId",
  as: "schoolAdminProfile",
});
SchoolAdminModel.belongsTo(UserModel, { foreignKey: "userId", as: "user" });

// User & SuperAdmin
UserModel.hasOne(SuperAdminModel, {
  foreignKey: "userId",
  as: "superAdminProfile",
});
SuperAdminModel.belongsTo(UserModel, { foreignKey: "userId", as: "user" });

// User & Teacher
UserModel.hasOne(TeacherModel, { foreignKey: "userId", as: "teacherProfile" });
TeacherModel.belongsTo(UserModel, { foreignKey: "userId", as: "user" });

// School & Grade
SchoolModel.hasMany(GradeModel, { foreignKey: "schoolId", as: "grades" });
GradeModel.belongsTo(SchoolModel, { foreignKey: "schoolId", as: "school" });

// School & Class
SchoolModel.hasMany(ClassModel, { foreignKey: "schoolId", as: "classes" });
ClassModel.belongsTo(SchoolModel, { foreignKey: "schoolId", as: "school" });

// Grade & Class
GradeModel.hasMany(ClassModel, { foreignKey: "gradeId", as: "classes" });
ClassModel.belongsTo(GradeModel, { foreignKey: "gradeId", as: "grade" });

// MembershipRequest Associations
UserModel.hasMany(MembershipRequestModel, {
  foreignKey: "userId",
  as: "membershipRequests",
});
MembershipRequestModel.belongsTo(UserModel, {
  foreignKey: "userId",
  as: "user",
});

SchoolModel.hasMany(MembershipRequestModel, {
  foreignKey: "schoolId",
  as: "membershipRequests",
});
MembershipRequestModel.belongsTo(SchoolModel, {
  foreignKey: "schoolId",
  as: "school",
});

ClassModel.hasMany(MembershipRequestModel, {
  foreignKey: "classId",
  as: "membershipRequests",
});
MembershipRequestModel.belongsTo(ClassModel, {
  foreignKey: "classId",
  as: "class",
});
