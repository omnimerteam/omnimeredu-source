import { Router } from "express";

// Models → Repo → Service → Controller
import { MembershipRequest } from "../../../domain/models/";
import { MembershipRequestRepository } from "../../../domain/repositories";
import { MembershipRequestService } from "../../../domain/services";
import { MembershipRequestController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";
import { ActivityLogRepository } from "../../../domain/repositories";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";

// Validators
import { objectIdParamSchema } from "../../validators/common/params/params.validator";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import { createPaginationSchemaWithSortAndFilter } from "../../validators/common/query/query.validator";
import {
  createMembershipRequestBodySchema,
  updateMembershipRequestBodySchema,
  updateStatusMembershipRequestBodySchema,
} from "../../validators/app/membershipRequest/membershipRequest.validator";

// Init Dependencies
const membershipRequestRepo = new MembershipRequestRepository(
  MembershipRequest
);
const logger = new DefaultLogger(new ActivityLogRepository());
const membershipRequestService = new MembershipRequestService(
  membershipRequestRepo,
  logger
);
const membershipRequestController = new MembershipRequestController(
  membershipRequestService
);

// Router
const router = Router();

// Custom Validate
const getAllMemberRequestPaginationSchema =
  createPaginationSchemaWithSortAndFilter(
    ["createdAt"],
    ["role", "action", "status"]
  );

/**
 * ROUTE DEFINITIONS
 */

// ✅ Lấy tất cả membership request
router.get(
  "/",
  validateData({
    headers: authHeaderSchema,
    query: getAllMemberRequestPaginationSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req, res, next) =>
    membershipRequestController.getAllMembershipRequest(req, res, next)
);

// ✅ Lấy membership request theo ID
router.get(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyFirebaseToken,
  (req, res, next) =>
    membershipRequestController.getMemberRequestById(req, res, next)
);

// ✅ Tạo membership request
router.post(
  "/",
  validateData({
    headers: authHeaderSchema,
    body: createMembershipRequestBodySchema,
  }),
  verifyFirebaseToken,
  (req, res, next) =>
    membershipRequestController.createMemberRequest(req, res, next)
);

// ✅ Cập nhật membership request
router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
    body: updateMembershipRequestBodySchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req, res, next) =>
    membershipRequestController.updateMemberRequest(req, res, next)
);

// ✅ Xóa membership request
router.delete(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req, res, next) =>
    membershipRequestController.deleteMemberRequest(req, res, next)
);

// ✅ Cập nhật action (dành cho SchoolAdmin phê duyệt)
router.patch(
  "/:id/status",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
    body: updateStatusMembershipRequestBodySchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SchoolAdmin"]),
  (req, res, next) =>
    membershipRequestController.updateStatusMemberRequest(req, res, next)
);

export default router;
