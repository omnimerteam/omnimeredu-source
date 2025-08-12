// src/middlewares/validateData.ts
import { Request, Response, NextFunction } from "express";
import { z, ZodError, ZodSchema } from "zod";
import { sendError } from "../utils/ResponseHelper";

interface ValidationSchemas {
  body?: ZodSchema<any>;
  query?: ZodSchema<any>;
  params?: ZodSchema<any>;
}

export const validateData = (schemas: ValidationSchemas) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      if (schemas.body) req.body = schemas.body.parse(req.body);
      if (schemas.query) req.query = schemas.query.parse(req.query);
      if (schemas.params) req.params = schemas.params.parse(req.params);

      next();
      return;
    } catch (error) {
      if (error instanceof ZodError) {
        const errorMessages = error.issues.map((issue) => ({
          field: issue.path.join("."),
          message: issue.message,
        }));

        sendError(res, "Dữ liệu yêu cầu không hợp lệ", 400, errorMessages);
        return;
      }

      sendError(res, "Lỗi hệ thống", 500, error);
      return;
    }
  };
};
