import { NextFunction } from "express";
import NewsService from "../services/news.services";

class NewsController {
  private readonly newsService: NewsService;

  constructor(newsService: NewsService) {
    this.newsService = newsService;
  }

  async getNewsBySchoolID(
    req: Request,
    res: Request,
    next: NextFunction
  ): Promise<void> {
    try {
    } catch {}
  }
}
