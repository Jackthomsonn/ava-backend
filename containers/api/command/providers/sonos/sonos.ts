import {
  SendCommandResponse,
  CommandStatus,
} from "../../types/command";
import { CommandProvider } from "../provider";

type SonosData = {};

export class SonosProvider implements CommandProvider {
  run(data: SonosData): SendCommandResponse {
    // Do something with data here

    return {
      executed_provider: this.constructor.name,
      status: CommandStatus.SUCCESS,
      message: "The command was successfully sent",
    };
  }
}