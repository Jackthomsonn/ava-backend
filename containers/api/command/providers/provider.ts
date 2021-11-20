import { SendCommandResponse } from "../types/command";

export interface CommandProvider {
  run(data: any): SendCommandResponse;
}
