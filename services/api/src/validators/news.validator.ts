import { NewsSchema } from "../schemas/News.schema";

export const createNewsBodySchema = NewsSchema.omit({
  _id: true,
  publishedAt: true, // thường MongoDB tự set
});

export const updateNewsBodySchema = NewsSchema.partial({
  title: true,
  content: true,
  imageUrl: true,
  schoolId: true,
  isPublic: true,
  tags: true,
});
