import { LoggerService, LogLevel, ValidationPipe } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { APIModule } from "./api.module";
import { env } from "process";

class AvaLogger implements LoggerService {
  private logLevels: LogLevel[];

  log(message: any, ...optionalParams: any[]) {
    if (this.logLevels.includes('log')) {
      console.log(`[AVA:LOG] - ${message}`);
    }
  }

  error(message: any, ...optionalParams: any[]) {
    if (this.logLevels.includes('error')) {
      console.log(`[AVA:ERROR] - ${message}`);
    }
  }

  warn(message: any, ...optionalParams: any[]) {
    if (this.logLevels.includes('warn')) {
      console.log(`[AVA:WARN] - ${message}`);
    }
  }

  debug(message: any, ...optionalParams: any[]) {
    if (this.logLevels.includes('debug')) {
      console.log(`[AVA:DEBUG] - ${message}`);
    }
  }

  verbose(message: any, ...optionalParams: any[]) {
    if (this.logLevels.includes('verbose')) {
      console.log(`[AVA:VERBOSE] - ${message}`);
    }
  }

  setLogLevels(levels: LogLevel[]) {
    this.logLevels = levels;
  }
}

async function bootstrap() {
  const logger = new AvaLogger();

  logger.setLogLevels(["log", "warn"])

  const app = await NestFactory.create(APIModule, { logger });

  app.useGlobalPipes(new ValidationPipe({ forbidUnknownValues: true }));

  await app.listen(env.PORT);
}

bootstrap();
