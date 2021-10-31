import { Controller, Get } from "@nestjs/common";
import { CommandService } from "./command.service";

@Controller()
export class CommandController {
  constructor(private readonly appService: CommandService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
