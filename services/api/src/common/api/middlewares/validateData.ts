// src/middlewares/validateData.ts
import { Request, Response, NextFunction } from "express";
import { z, ZodError, ZodSchema } from "zod";
import { cleanErrorMessage, sendError } from "../../utils/ResponseHelper";
import chalk from "chalk";

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
        const combinedMessage = error.issues
          .map((issue) => issue.message)
          .join("; ");

        sendError(
          res,
          "Dữ liệu yêu cầu không hợp lệ",
          400,
          cleanErrorMessage(combinedMessage)
        );
        return;
      }

      sendError(res, "Lỗi hệ thống", 500, cleanErrorMessage(error));
      return;
    }
  };
};
