import { Module } from "@nestjs/common";
import { DeviceResolver } from "./device.resolver";
import { DeviceService } from "./device.service";

@Module({
  providers: [DeviceService, DeviceResolver],
})
export class DeviceModule {}
