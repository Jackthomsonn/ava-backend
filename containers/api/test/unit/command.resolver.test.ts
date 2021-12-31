// import { CommandStatus, PossibleCommand } from "../../device/types/command";

// import { CommandService } from "../../device/device.service";
// import { CommandResolver } from "../../device/device.resolver";

// describe("CommandResolver", () => {
//   let commandResolver: CommandResolver;
//   let commandService: CommandService;

//   beforeEach(() => {
//     commandService = new CommandService();
//     commandResolver = new CommandResolver(commandService);
//   });

//   describe("sendCommand", () => {
//     it("should send a command", async () => {
//       // Arrange
//       jest.spyOn(commandService, "sendCommand").mockImplementation(() => {
//         return {
//           executed_provider: "testCommand",
//           status: CommandStatus.SUCCESS,
//           message: "Test passed",
//         };
//       });

//       // Act
//       const result = commandResolver.sendCommand({
//         command: PossibleCommand.SENSOR,
//         data: "",
//       });

//       // Assert
//       expect(result).toEqual({
//         executed_provider: "testCommand",
//         status: CommandStatus.SUCCESS,
//         message: "Test passed",
//       });
//     });
//   });
// });
