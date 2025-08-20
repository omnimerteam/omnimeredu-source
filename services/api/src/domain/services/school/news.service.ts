import { ILogger } from "../../../common/interfaces/logger.interface";
import { INews } from "../../models";
import { NewsRepository } from "../../repositories";

class NewsService {
  private readonly newsRepository: NewsRepository;
  private readonly logger: ILogger;

  constructor(newsRepository: NewsRepository, logger: ILogger) {
    this.newsRepository = newsRepository;
    this.logger = logger;
  }

  /**
   * Lấy danh sách bài đăng trường: nếu là người của trường
   * thì sẽ hiện tất cả nếu không thì hiện bài được  công khai
   * @param actorId id của người lấy
   * @param userRole vai trò của người lấy
   * @param schoolId trường học muốn lấy
   * @param actorSchoolId trường học của người lấy
   * @param options
   * @returns schoolNews
   */
  async getNewsBySchoolID(
    actorId: string,
    userRole: string,
    schoolId: string,
    actorSchoolId: string,
    options?: { page?: number; limit?: number; sort?: any }
  ): Promise<INews[]> {
    try {
      const isSameSchool = schoolId === actorSchoolId;

      const schoolNews = isSameSchool
        ? await this.newsRepository.getNewsBySchoolID(schoolId, options)
        : await this.newsRepository.getNewsBySchoolIdIsPublic(
            schoolId,
            options
          );

      await this.logger.log({
        userId: actorId,
        action: "GET_NEWS_OF_SCHOOL",
        roleSnapshot: userRole,
        metadata: {
          isPublic: !isSameSchool, // ✅ log chính xác
          options,
          count: schoolNews.length,
        },
      });

      return schoolNews;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_NEWS_OF_SCHOOL_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getNewsByID(
    actorId: string,
    userRole: string,
    schoolActorId: string,
    id: string
  ) {
    try {
      const news = await this.newsRepository.findById(id);

      if (!news) {
        return null;
      }

      // Kiểm tra quyền
      if (
        news?.isPublic === false &&
        news?.schoolId?.toString() !== schoolActorId
      ) {
        throw new Error("Bạn không có quyền xem bài viết này");
      }

      await this.logger.log({
        userId: actorId,
        action: "GET_NEWS_BY_ID",
        roleSnapshot: userRole,
        targetId: news.id,
      });

      return news;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_NEWS_BY_ID_FAILED",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createNews(
    newsData: Partial<INews>,
    actorId: string,
    userRole: string
  ) {
    try {
      const news = await this.newsRepository.create(newsData);
      await this.logger.log({
        userId: actorId,
        action: "POST_NEWS",
        roleSnapshot: userRole,
        targetId: news.id,
      });

      return news;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "POST_NEWS_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateNews(
    id: string,
    updateNewsData: Partial<INews>,
    actorId: string,
    userRole: string
  ) {
    try {
      const newsUpdate = await this.newsRepository.update(id, updateNewsData);
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_NEWS",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!newsUpdate },
      });

      return updateNewsData;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_NEWS_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateNewsVisibility(
    id: string,
    isPublic: boolean,
    actorId: string,
    userRole: string
  ) {
    try {
      const newsUpdate = await this.newsRepository.update(id, { isPublic });

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_NEWS_VISIBILITY",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!newsUpdate, newVisibility: isPublic },
      });

      return { id, isPublic };
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_NEWS_VISIBILITY_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });

      throw error;
    }
  }

  async deleteNews(id: string, actorId: string, userRole: string) {
    try {
      const newsDelete = await this.newsRepository.delete(id);
      await this.logger.log({
        userId: actorId,
        action: "DELETE_NEWS",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!newsDelete },
      });

      return newsDelete;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_NEWS_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default NewsService;
