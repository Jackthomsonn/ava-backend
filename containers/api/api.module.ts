import { Module } from "@nestjs/common";
import { CommandModule } from "./services/command/command.module";

@Module({
  imports: [
    CommandModule,
  ]
})
export class APIModule { }
