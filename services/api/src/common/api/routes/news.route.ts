import { NextFunction, Request, Response, Router } from "express";
const router = Router();

// Models → Repo → Service → Controller
import { News } from "../../../domain/models";
import {
  NewsRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";
import { NewsService } from "../../../domain/services";
import { NewsController } from "../../../domain/controllers";

// Logger & Activity Log

import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyJWTToken } from "../middlewares/verifyJWTToken.middleware";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { createPaginationSchemaWithSort } from "../../validators/common/query/query.validator";

// Validate
import {
  objectIdParamSchema,
  schoolIdParamSchema,
} from "../../validators/common/params/params.validator";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import {
  createNewsBodySchema,
  updateNewsBodySchema,
  updateNewsVisibilityBodySchema,
} from "../../validators/app/news/news.validator";

const newsRepository = new NewsRepository(News);
const logger = new DefaultLogger(new ActivityLogRepository());
const newsService = new NewsService(newsRepository, logger);
const newsController = new NewsController(newsService);

const getNewsBySchoolIdPaginationSchema = createPaginationSchemaWithSort([
  "title",
  "schoolId",
  "publishedAt",
]);

/**
 * Lấy toàn bộ bài viết theo trường được sắp xếp theo thời gian đăng
 */
router.get(
  "/:schoolId",
  validateData({
    headers: authHeaderSchema,
    params: schoolIdParamSchema,
    query: getNewsBySchoolIdPaginationSchema,
  }),
  verifyJWTToken,
  (req, res, next) => newsController.getNewsBySchoolID(req, res, next)
);

/**
 * Lấy chi tiết thông tin của bài đăng
 */
router.get(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  (req, res, next) => newsController.getNewsByID(req, res, next)
);

/**
 * Tạo bài đăng mới
 * Chỉ có SchoolAdmin được đăng do trường mình quản lý
 */
router.post(
  "/",
  validateData({
    headers: authHeaderSchema,
    body: createNewsBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SchoolAdmin"]),
  (req, res, next) => newsController.createNews(req, res, next)
);

/**
 * Chỉnh sửa bài đăng
 * Chỉ có SchoolAdmin được chỉnh sửa bài đăng do mình tạo và của trường mình quản lý
 */
router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
    body: updateNewsBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SchoolAdmin"]),
  (req, res, next) => newsController.updateNews(req, res, next)
);

/**
 * Chỉnh sửa chế độ công khai/riêng tư
 * Chỉ có schoolAdmin được chỉnh sửa chế độ
 */
router.patch(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
    body: updateNewsVisibilityBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SchoolAdmin"]),
  (req, res, next) => newsController.updateNewsVisibility(req, res, next)
);

/**
 * Xóa bài đăng
 * Chỉ có SchoolAdmin nào tạo thì được xóa
 */
router.delete(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SchoolAdmin"]),
  (req, res, next) => newsController.deleteNews(req, res, next)
);

export default router;
