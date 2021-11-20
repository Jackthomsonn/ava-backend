import {
  SendCommandResponse,
  CommandStatus,
} from "../../types/command";
import { CommandProvider } from "../provider";

type SensorData = {};

export class SensorProvider implements CommandProvider {
  run(data: SensorData): SendCommandResponse {
    // Do something with data here

    return {
      executed_provider: this.constructor.name,
      status: CommandStatus.SUCCESS,
      message: "The command was successfully sent",
    };
  }
}
