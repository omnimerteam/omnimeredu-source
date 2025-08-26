// src/middlewares/validateData.ts
import { Request, Response, NextFunction } from "express";
import { z, ZodError, ZodSchema } from "zod";
import { sendError } from "../../utils/ResponseHelper";

interface ValidationSchemas {
  body?: ZodSchema<any>;
  query?: ZodSchema<any>;
  params?: ZodSchema<any>;
  headers?: ZodSchema<any>;
}

export const validateData = (schemas: ValidationSchemas) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      if (schemas.body) {
        req.body = schemas.body.parse(req.body);
      }

      if (schemas.query) {
        const parsedQuery = schemas.query.parse(req.query);
        Object.assign(req.query, parsedQuery);
      }

      if (schemas.params) {
        const parsedParams = schemas.params.parse(req.params);
        Object.assign(req.params, parsedParams);
      }

      if (schemas.headers) {
        const parsedHeaders = schemas.headers.parse({
          authorization: req.headers["authorization"],
        });
        (req as any).authHeader = parsedHeaders.authorization;
      }

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

      sendError(res, `${error}`, 500, error);
      return;
    }
  };
};
