import { IsArray, IsString } from "class-validator";

export type SendCommand = {
  command: string;
  args: string[];
};

export class SendCommandDTO implements SendCommand {
  @IsString({ message: "Command must be a string" })
  command: string;

  @IsArray({ message: "Command args must be an array" })
  args: string[];
}

export enum CommandStatus {
  PASSED = "passed",
  ERROR = "error",
};

export type SendCommandResponse = {
  executed_command: string;
  status: CommandStatus;
  message: string;
};

export type GetCommandResponse = {
  [key: string]: {
    name: string;
    description: string;
    parameters: any[];
  }
}