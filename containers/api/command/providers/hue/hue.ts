import {
  CommandStatus,
  SendCommandResponse,
} from "../../types/command";
import { CommandProvider } from "../provider";

type HueData = {};

export class HueProvider implements CommandProvider {
  run(data: HueData): SendCommandResponse {
    // Do something with data here

    return {
      executed_provider: this.constructor.name,
      status: CommandStatus.SUCCESS,
      message: "The command was successfully sent",
    };
  }
}
