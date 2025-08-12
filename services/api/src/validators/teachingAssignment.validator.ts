import { z } from "zod";
import { TeachingAssignmentSchema } from "../schemas/TeachingAssignment.schema";

export const createTeachingAssignmentBodySchema = TeachingAssignmentSchema.omit(
  { _id: true }
);

export const updateTeachingAssignmentBodySchema =
  TeachingAssignmentSchema.partial({
    teacherId: true,
    classId: true,
    subject: true,
    isMain: true,
  });
