import { NewsSchema } from "./News.schema";

export const createNewsBodySchema = NewsSchema.omit({
  _id: true,
  publishedAt: true,
});

export const updateNewsBodySchema = NewsSchema.partial({
  title: true,
  content: true,
  imageUrl: true,
  schoolId: true,
  isPublic: true,
  tags: true,
});
