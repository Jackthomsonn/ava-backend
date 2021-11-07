import { CommandStatus } from "../../shared/types/command";
import { CommandController } from "../../command/command.controller";
import { CommandService } from "../../command/command.service";

describe('CommandService', () => {
  let commandService: CommandService;

  beforeEach(() => {
    commandService = new CommandService();
  });

  describe('getCommands', () => {
    it('should return a valid json of commands back', async () => {
      // Act
      const result = commandService.getCommands();

      // Assert
      expect(result).toEqual({
        lightOn: {
          name: 'lightOn',
          description: 'Turns on the light',
          parameters: [],
        },
        lightOff: {
          name: 'lightOff',
          description: 'Turns off the light',
          parameters: [],
        }
      });
    });
  });

  describe('sendCommand', () => {
    it('should send a command', async () => {
      // Act
      const result = commandService.sendCommand({ command: "testCommand", args: [] });

      // Assert
      expect(result).toEqual({
        executed_command: 'testCommand',
        status: CommandStatus.PASSED,
        message: "Command sent"
      });
    });
  });
});