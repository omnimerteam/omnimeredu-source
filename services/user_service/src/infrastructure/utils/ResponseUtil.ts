import { Response } from "express";

export class ResponseUtil {
  static sendSuccess(
    res: Response,
    message: string = "Success",
    data: any = null,
    statusCode: number = 200
  ) {
    const response: any = {
      success: true,
      message,
    };

    if (data !== null && data !== undefined) {
      response.data = data;
    }

    return res.status(statusCode).json(response);
  }

  static sendError(
    res: Response,
    message: string = "Error",
    error: any = null,
    statusCode: number = 400
  ) {
    // Log error to console so it's visible in terminal
    console.error(`❌ [ResponseUtil] ${message}:`, error);

    const response: any = {
      success: false,
      message,
    };

    // Include error details for developers if provided, or if in dev mode
    if (error) {
      response.error = error instanceof Error ? error.message : error;
      if (process.env.NODE_ENV === "development") {
        response.stack = error instanceof Error ? error.stack : undefined;
      }
    }

    return res.status(statusCode).json(response);
  }
}
