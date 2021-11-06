import { Body, Controller, Get, Post, ValidationPipe } from "@nestjs/common";
import { GetCommandResponse, SendCommandDTO } from "../../shared/types/command";
import { CommandService } from "./command.service";

@Controller()
export class CommandController {
  constructor(private readonly commandService: CommandService) { }

  @Get()
  getCommands(): GetCommandResponse {
    return this.commandService.getCommands();
  }

  @Post()
  sendCommand(@Body() sendCommandDTO: SendCommandDTO): object {
    return this.commandService.sendCommand(sendCommandDTO);
  }
}
