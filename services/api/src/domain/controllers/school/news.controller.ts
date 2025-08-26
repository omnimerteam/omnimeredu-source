import { NextFunction, Request, Response } from "express";
import chalk from "chalk";

import { NewsService } from "../../services";
import {
  sendCreated,
  sendEmpty,
  sendForbidden,
  sendNotFound,
  sendSuccess,
  sendUnauthorized,
} from "../../../common/utils/ResponseHelper";
import { buildQueryOptions } from "../../../common/utils/buildQueryOptions";

class NewsController {
  private readonly newsService: NewsService;

  constructor(newsService: NewsService) {
    this.newsService = newsService;
  }

  /**
   * Lấy danh sách các bài đăng theo trường
   * @param req : user, roles, params.schoolId
   * @param res : schoolNews
   * @param next : error
   * @returns
   */
  async getNewsBySchoolID(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    const schoolId = req.params.schoolId;

    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    if (!schoolId) {
      sendNotFound(res, "Không tìm thấy bài viết trường");
      return;
    }

    const actorSchoolId = req.user?.schoolId?.toString();
    const options = buildQueryOptions(req.query as any);

    try {
      const schoolNews = await this.newsService.getNewsBySchoolID(
        actorId,
        userRole,
        schoolId,
        actorSchoolId,
        options
      );

      if (!schoolNews || schoolNews.length === 0) {
        console.log(chalk.yellow("[NEWS] No school new found for user"));
        sendEmpty(res, "Trường chưa có bài đăng");
        return;
      }

      sendSuccess(res, schoolNews, "Danh sách tin tức trường");
      return;
    } catch (error) {
      console.log(chalk.red("[NEWS] ❌ Get school news failed"), error);
      return next(error);
    }
  }
  async getNewsByID(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    const id = req.params.id;

    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    const schoolActorId = req.user?.schoolId?.toString();

    if (!id) {
      sendNotFound(res, "Không tìm thấy bài viết này");
      return;
    }

    try {
      const news = await this.newsService.getNewsByID(
        actorId,
        userRole,
        schoolActorId,
        id
      );

      if (!news) {
        console.log(chalk.yellow("[NEWS] News not found by ID"));
        sendNotFound(res, "Không tìm thấy bài viết này");
        return;
      }

      sendSuccess(res, news, "Danh sách tin tức trường");
      return;
    } catch (error) {
      console.log(chalk.red("[NEWS] ❌ Get news by id is failed"), error);
      return next(error);
    }
  }

  async createNews(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;

    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    const newsData = req.body;

    const actorSchoolId = req.user?.schoolId?.toString();

    if (actorSchoolId !== newsData.schoolId) {
      sendForbidden(res);
      return;
    }

    try {
      const news = await this.newsService.createNews(
        newsData,
        actorId,
        userRole
      );

      sendCreated(res, news, "Đăng tin tức thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[NEWS] ❌ Create news is failed"), error);
      return next(error);
    }
  }

  async updateNews(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;

    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    const id = req.params.id;
    const actorSchoolId = req.user?.schoolId?.toString();

    if (actorSchoolId !== id) {
      sendForbidden(res);
      return;
    }

    const updateNewsData = req.body;

    try {
      const news = await this.newsService.updateNews(
        id,
        updateNewsData,
        actorId,
        userRole
      );

      sendSuccess(res, news, "Cập nhật bài viết thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[NEWS] ❌ Update news by id is failed"), error);
      return next(error);
    }
  }

  async updateNewsVisibility(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;

    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    const id = req.params.id;
    const actorSchoolId = req.user?.schoolId?.toString();

    if (actorSchoolId !== id) {
      sendForbidden(res);
      return;
    }

    const { isPublic } = req.body;

    try {
      const newsUpdate = await this.newsService.updateNewsVisibility(
        id,
        isPublic,
        actorId,
        userRole
      );

      sendSuccess(
        res,
        newsUpdate,
        `Bài viết đã cập nhật chế độ ${isPublic ? "công khai" : "riêng tư"}`
      );
      return;
    } catch (error) {
      console.log(
        chalk.red("[NEWS] ❌ Update news visibility by id is failed"),
        error
      );
      return next(error);
    }
  }

  async deleteNews(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;

    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    const id = req.params.id;
    const actorSchoolId = req.user?.schoolId?.toString();

    if (actorSchoolId !== id) {
      sendForbidden(res);
      return;
    }

    try {
      const newsDelete = await this.newsService.deleteNews(
        id,
        actorId,
        userRole
      );

      sendSuccess(res, newsDelete, "Xóa bài viết thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[NEWS] ❌ Delete news by id is failed"), error);
      return next(error);
    }
  }
}

export default NewsController;
