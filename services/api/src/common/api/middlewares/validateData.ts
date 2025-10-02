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

function removeEmpty(obj: Record<string, any>) {
  return Object.fromEntries(
    Object.entries(obj).filter(
      ([, v]) => v !== null && v !== "" && v !== undefined
    )
  );
}

export const validateData = (schemas: ValidationSchemas) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      console.log(chalk.green("Request"), req.query);
      // console.log(chalk.green("Schemas"), schemas);

      if (schemas.body) {
        req.body = schemas.body.parse(removeEmpty(req.body));
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

        console.log(chalk.red("[VALIDATION] ❌ Validation failed:"), error);

        sendError(res, cleanErrorMessage(combinedMessage), 400);
        return;
      }

      sendError(res, "Lỗi hệ thống", 500, cleanErrorMessage(error));
      return;
    }
  };
};
