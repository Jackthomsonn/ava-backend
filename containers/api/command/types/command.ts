import {
  Field,
  InputType,
  ObjectType,
  registerEnumType,
} from "@nestjs/graphql";
import { IsEnum, IsString } from "class-validator";

// Enums
export enum PossibleCommand {
  HUE = "hue",
  SONOS = "sonos",
  SENSOR = "sensor",
}

export enum CommandStatus {
  SUCCESS = "SUCCESS",
  FAILED = "FAILED",
}

// Register enums
registerEnumType(PossibleCommand, {
  name: "PossibleCommand",
});

// Setup object types
@ObjectType()
export class SendCommandResponse {
  @Field({ description: "The name of the executed provider" })
  executed_provider: string;

  @Field({ description: "The status of the executed command" })
  status: CommandStatus;

  @Field({ description: "The message of the executed command" })
  message: string;
}

@ObjectType()
export class Command {
  @Field({ description: "The name of the command" })
  name: string;
}

// Setup input types
@InputType()
export class SendCommandInput {
  @Field(() => PossibleCommand, { description: "The name of the command" })
  @IsEnum(PossibleCommand)
  command: PossibleCommand;

  @Field(() => String, {
    description:
      "The data for this specific device. Must be supplied as a string",
  })
  @IsString()
  data: string;
}
