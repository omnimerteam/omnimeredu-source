import { NewsSchema } from "./News.schema";

export const createNewsBodySchema = NewsSchema.omit({
  _id: true,
});

// Body khi update
export const updateNewsBodySchema = NewsSchema.partial({
  title: true,
  quillDelta: true,
  imagePath: true,
  imageUrl: true,
  schoolId: true,
  isPublic: true,
  tags: true,
});

export const updateNewsVisibilityBodySchema = NewsSchema.pick({
  isPublic: true,
});
