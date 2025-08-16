import { NextFunction, Request, Response, Router } from "express";
const router = Router();

/**
 * Lấy toàn bộ bài viết theo trường được sắp xếp theo thời gian đăng
 */
router.get("/:schoolId");

/**
 * Lấy chi tiết thông tin của bài đăng
 */
router.get("/:id");

/**
 * Tạo bài đăng mới
 * Chỉ có SchoolAdmin được đăng do trường mình quản lý
 */
router.post("/");

/**
 * Chỉnh sửa bài đăng
 * Chỉ có SchoolAdmin được chỉnh sửa bài đăng do mình tạo và của trường mình quản lý
 */
router.put("/");

/**
 * Chỉnh sửa chế độ công khai/riêng tư
 * Chỉ có schoolAdmin được chỉnh sửa chế độ
 */
router.patch("/");

/**
 * Xóa bài đăng
 * Chỉ có SchoolAdmin nào tạo thì được xóa
 */
router.delete("/");

export default router;
