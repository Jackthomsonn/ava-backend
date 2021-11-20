import { Module } from "@nestjs/common";
import { CommandResolver } from "./command.resolver";
import { CommandService } from "./command.service";

@Module({
  providers: [CommandService, CommandResolver],
})
export class CommandModule {}
