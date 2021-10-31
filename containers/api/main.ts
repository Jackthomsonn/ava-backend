import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const port: number = process.env.PORT as any;

  await app.listen(port);
}

bootstrap();
