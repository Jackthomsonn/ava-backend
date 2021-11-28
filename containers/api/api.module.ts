import { Module } from "@nestjs/common";
import { GraphQLModule } from "@nestjs/graphql";
import { join } from "path";
import { CommandModule } from "./command/command.module";

@Module({
  imports: [
    CommandModule,
    GraphQLModule.forRoot({
      playground: true,
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
