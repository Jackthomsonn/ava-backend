import { ValidationPipe } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { APIModule } from "./api.module";
import { env } from "process";
import { AvaLogger } from "./shared/loggers/logger";

async function bootstrap() {
  const logger = new AvaLogger();

  logger.setLogLevels(["log", "warn"]);

  const app = await NestFactory.create(APIModule, { logger });

  app.useGlobalPipes(new ValidationPipe({ forbidUnknownValues: true }));

  await app.listen(env.PORT);
}

bootstrap();
