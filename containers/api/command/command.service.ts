import { Injectable } from "@nestjs/common";
import {
  SendCommandResponse,
  PossibleCommand,
  SendCommandInput,
} from "./types/command";
import { HueProvider } from "./providers/hue/hue";
import { SensorProvider } from "./providers/sensor/sensor";
import { SonosProvider } from "./providers/sonos/sonos";

@Injectable()
export class CommandService {
  sendCommand(request: SendCommandInput): SendCommandResponse {
    const provider = this.getProviderImpl(request.command);

    return provider.run(request.data);
  }

  private getProviderImpl(command: PossibleCommand) {
    switch (command) {
      case PossibleCommand.HUE:
        return new HueProvider();
      case PossibleCommand.SONOS:
        return new SonosProvider();
      case PossibleCommand.SENSOR:
        return new SensorProvider();
    }
  }
}
