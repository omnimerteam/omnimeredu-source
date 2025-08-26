import { ClientSession } from "mongoose";

export interface IRegisterHandler {
  handle(user: any, payload: any, session: ClientSession): Promise<void>;
}
