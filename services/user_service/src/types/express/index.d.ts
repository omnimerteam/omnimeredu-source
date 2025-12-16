import { TokenPayload } from "shared-lib";

declare global {
  namespace Express {
    interface Request {
      user?: TokenPayload;
    }
  }
}
