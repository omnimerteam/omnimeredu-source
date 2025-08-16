import { ILogger } from "../interfaces/logger.interface";
import NewsRepository from "../repositories/news.repository";

class NewsService {
  private readonly newsRepository: NewsRepository;
  private readonly logger: ILogger;

  constructor(newsRepository: NewsRepository, logger: ILogger) {
    this.newsRepository = newsRepository;
    this.logger = logger;
  }

  async getNewsBySchoolID(
    actorId: string,
    userRole: string,
    schoolId: string,
    options?: { page?: number; limit?: number; sort?: any }
  ) {
    try {
      const news = await this.newsRepository.getNewsBySchoolID(schoolId);

      await this.logger.log({
        userId: actorId,
        action: "GET_NEWS_OF_SCHOOL",
        roleSnapshot: userRole,
        metadata: {
          options,
          //count: classes.length,
        },
      });
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
}

export default NewsService;
