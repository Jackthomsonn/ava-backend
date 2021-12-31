import { Args, Mutation, Query, Resolver } from "@nestjs/graphql";
import {
  CreateDeviceInputType,
  DeviceObjectType,
  DeviceResponse,
} from "./types/device";
import { DeviceService } from "./device.service";
import { UseGuards } from "@nestjs/common";
import { AuthGuard } from "../shared/guards/auth";
import { Device } from "@prisma/client";

@Resolver()
export class DeviceResolver {
  constructor(private deviceService: DeviceService) {}

  @Query(() => [DeviceObjectType], { description: "Get all devices" })
  @UseGuards(AuthGuard({ permissions: ["get:devices"] }))
  async getDevices(): Promise<Device[]> {
    return this.deviceService.getDevices();
  }

  @Mutation(() => DeviceResponse, { description: "Create a new device" })
  async createDevice(
    @Args("device") device: CreateDeviceInputType
  ): Promise<DeviceResponse> {
    const createdDevice = await this.deviceService.createDevice(device);

    return { device: createdDevice };
  }
}
