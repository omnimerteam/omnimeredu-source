import { TuitionZodSchema } from "./Tuition.schema";

export const createTuitionBodySchema = TuitionZodSchema.omit({ _id: true });

export const updateTuitionBodySchema = TuitionZodSchema.partial();
