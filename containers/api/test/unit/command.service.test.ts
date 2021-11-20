import { CommandStatus, PossibleCommand } from "../../command/types/command";
import { CommandService } from "../../command/command.service";

describe("CommandService", () => {
  let commandService: CommandService;

  beforeEach(() => {
    commandService = new CommandService();
  });

  describe("sendCommand", () => {
    it("should send a command", async () => {
      // Act
      const result = commandService.sendCommand({
        command: PossibleCommand.SONOS,
        data: "",
      });

      // Assert
      expect(result).toEqual({
        executed_provider: "testCommand",
        status: CommandStatus.SUCCESS,
        message: "Command sent",
      });
    });
  });
});
