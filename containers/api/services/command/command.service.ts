import { Injectable } from '@nestjs/common';
import { SendCommand, SendCommandResponse, CommandStatus, GetCommandResponse } from '../../shared/types/command';

@Injectable()
export class CommandService {
  getCommands(): GetCommandResponse {
    return {
      lightOn: {
        name: 'lightOn',
        description: 'Turns on the light',
        parameters: [],
      },
      lightOff: {
        name: 'lightOff',
        description: 'Turns off the light',
        parameters: [],
      },
    }
  }

  sendCommand(data: SendCommand): SendCommandResponse {
    return {
      executed_command: data.command,
      status: CommandStatus.PASSED,
      message: 'Command sent',
    }
  }
}
