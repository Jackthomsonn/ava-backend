import { Module } from "@nestjs/common";
import { GraphQLModule } from "@nestjs/graphql";
import { join } from "path";
import { DeviceModule } from "./device/device.module";

@Module({
  imports: [
    DeviceModule,
    GraphQLModule.forRoot({
      playground: process.env.PLAYGROUND_ENABLED === "true",
      autoSchemaFile: join(process.cwd(), "schema.gql"),
      sortSchema: true,
      installSubscriptionHandlers: true,
      context: ({ req }) => {
        return { request: req };
      },
    }),
  ],
})
export class APIModule {}
