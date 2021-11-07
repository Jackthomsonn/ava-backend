import { Body, Controller, Get, Post } from "@nestjs/common";
import { GetCommandResponse, SendCommandDTO, SendCommandResponse } from "../shared/types/command";
import { CommandService } from "./command.service";

@Controller()
export class CommandController {
  constructor(private readonly commandService: CommandService) { }

  @Get()
  getCommands(): GetCommandResponse {
    return this.commandService.getCommands();
  }

  @Post()
  sendCommand(@Body() sendCommandDTO: SendCommandDTO): SendCommandResponse {
    return this.commandService.sendCommand(sendCommandDTO);
  }
}
