import "./schemas/UserReadSchema";
import "./schemas/UserFullReadSchema";
import "./schemas/SchoolReadSchema";
import "./schemas/GradeReadSchema";
import "./schemas/ClassReadSchema";
import "./schemas/MembershipRequestReadSchema";
import "./schemas/RoleReadSchema";
import "./schemas/SchoolAdminReadSchema";
import "./schemas/SuperAdminReadSchema";
import "./schemas/TeacherReadSchema";

export const initMongoDBModels = () => {
  // Just importing this file is enough to register models with Mongoose
  console.log("MongoDB Models Registered");
};
