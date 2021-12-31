import { Injectable } from "@nestjs/common";
import { PrismaClient } from "@prisma/client";
import { CreateDeviceInputType } from "./types/device";

@Injectable()
export class DeviceService {
  private prisma: PrismaClient;

  constructor() {
    this.prisma = new PrismaClient();
  }

  getDevices() {
    return this.prisma.device.findMany();
  }

  createDevice(data: CreateDeviceInputType) {
    return this.prisma.device.create({ data });
  }
}
