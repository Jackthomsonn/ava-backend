import { Module } from "@nestjs/common";
import { CommandController } from "./command/command.controller";
import { CommandService } from "./command/command.service";

@Module({
  imports: [],
  controllers: [CommandController],
  providers: [CommandService],
})
export class AppModule {}
