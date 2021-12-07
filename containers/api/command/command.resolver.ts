import { Args, Query, Mutation, Resolver, Subscription } from "@nestjs/graphql";
import {
  Command,
  PossibleCommand,
  SendCommandInput,
  SendCommandResponse,
} from "./types/command";
import { CommandService } from "./command.service";
import { PubSub } from "graphql-subscriptions";
import { UseGuards } from "@nestjs/common";
import { AuthGuard } from "../shared/guards/auth";

@Resolver()
export class CommandResolver {
  private pubsub: PubSub;
  constructor(private commandService: CommandService) {
    this.pubsub = new PubSub();
  }

  @Query(() => [Command], { description: "Get all command providers" })
  @UseGuards(AuthGuard({ permissions: ["get:command"] }))
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
  @UseGuards(AuthGuard({ permissions: ["send:command"] }))
  sendCommand(@Args("command") commandInput: SendCommandInput) {
    this.pubsub.publish("commandSent", {
      commandSent: { name: "Hue" } as Command,
    });

    return this.commandService.sendCommand(commandInput);
  }

  @Subscription(() => Command)
  commandSent() {
    return this.pubsub.asyncIterator("commandSent");
  }
}
