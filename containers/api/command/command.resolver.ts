import { Args, Query, Mutation, Resolver } from "@nestjs/graphql";
import {
  Command,
  PossibleCommand,
  SendCommandInput,
  SendCommandResponse,
} from "./types/command";
import { CommandService } from "./command.service";

@Resolver()
export class CommandResolver {
  constructor(private commandService: CommandService) {}

  @Query(() => [Command], { description: "Get all command providers" })
  async getProviders() {
    return [
      {
        name: PossibleCommand.HUE,
      },
      {
        name: PossibleCommand.SONOS,
      },
      {
        name: PossibleCommand.SENSOR,
      },
    ];
  }

  @Mutation(() => SendCommandResponse, {
    description: "Send a command to the device",
  })
  async sendCommand(@Args("command") commandInput: SendCommandInput) {
    return this.commandService.sendCommand(commandInput);
  }
}
