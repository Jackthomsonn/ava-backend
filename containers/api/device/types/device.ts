import {
  Field,
  InputType,
  ObjectType,
  registerEnumType,
} from "@nestjs/graphql";
import { DeviceType, Device } from "@prisma/client";
import { IsEnum, IsString } from "class-validator";

registerEnumType(DeviceType, {
  name: "DeviceType",
});

@ObjectType()
export class DeviceObjectType implements Device {
  @Field(() => String, { description: "The id of the device" })
  id: string;

  @Field(() => String, { description: "The name of the device" })
  name: string;

  @Field(() => DeviceType, { description: "The type of the device" })
  type: DeviceType;

  @Field(() => Date, { description: "When the device was created" })
  createdAt: Date;

  @Field(() => Date, { description: "When the device was updated" })
  updatedAt: Date;
}

@ObjectType()
export class DeviceResponse {
  @Field(() => DeviceObjectType, { description: "The created device" })
  device: DeviceObjectType;
}

@InputType()
export class CreateDeviceInputType implements Partial<Device> {
  @IsString()
  @Field(() => String, { description: "The name of the device" })
  name: string;

  @IsEnum(DeviceType)
  @Field(() => DeviceType, { description: "The type of the device" })
  type: DeviceType;
}
