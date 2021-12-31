// import { CommandStatus, PossibleCommand } from "../../device/types/command";
// import { CommandService } from "../../device/device.service";

// describe("CommandService", () => {
//   let commandService: CommandService;

//   beforeEach(() => {
//     commandService = new CommandService();
//   });

//   describe("sendCommand", () => {
//     it("should send a command for a sonos device", async () => {
//       // Act
//       const result = commandService.sendCommand({
//         command: PossibleCommand.SONOS,
//         data: "",
//       });

//       // Assert
//       expect(result).toEqual({
//         executed_provider: "SonosProvider",
//         status: CommandStatus.SUCCESS,
//         message: "The command was successfully sent",
//       });
//     });

//     it("should send a command for a sensor device", async () => {
//       // Act
//       const result = commandService.sendCommand({
//         command: PossibleCommand.SENSOR,
//         data: "",
//       });

//       // Assert
//       expect(result).toEqual({
//         executed_provider: "SensorProvider",
//         status: CommandStatus.SUCCESS,
//         message: "The command was successfully sent",
//       });
//     });

//     it("should send a command for a hue device", async () => {
//       // Act
//       const result = commandService.sendCommand({
//         command: PossibleCommand.HUE,
//         data: "",
//       });

//       // Assert
//       expect(result).toEqual({
//         executed_provider: "HueProvider",
//         status: CommandStatus.SUCCESS,
//         message: "The command was successfully sent",
//       });
//     });
//   });
// });
