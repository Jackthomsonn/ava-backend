import { CommandStatus } from "../../shared/types/command";
import { CommandController } from "../../command/command.controller";
import { CommandService } from "../../command/command.service";

describe('CommandController', () => {
  let commandController: CommandController;
  let commandService: CommandService;

  beforeEach(() => {
    commandService = new CommandService();
    commandController = new CommandController(commandService);
  });

  describe('getCommands', () => {
    it('should return a valid json of commands back', async () => {
      // Arrange
      jest.spyOn(commandService, 'getCommands').mockImplementation(() => {
        return {
          test: {
            name: "Test",
            description: "Test Impl",
            parameters: []
          }
        }
      });

      // Act
      const result = commandController.getCommands()

      // Assert
      expect(result).toEqual({
        test: {
          name: "Test",
          description: "Test Impl",
          parameters: []
        }
      });
    });
  });

  describe('sendCommand', () => {
    it('should send a command', async () => {
      // Arrange
      jest.spyOn(commandService, 'sendCommand').mockImplementation(() => {
        return {
          executed_command: 'testCommand',
          status: CommandStatus.PASSED,
          message: "Test passed"
        }
      });

      // Act
      const result = commandController.sendCommand({ command: 'testCommand', args: [] })

      // Assert
      expect(result).toEqual({
        executed_command: 'testCommand',
        status: CommandStatus.PASSED,
        message: "Test passed"
      });
    });
  });
});