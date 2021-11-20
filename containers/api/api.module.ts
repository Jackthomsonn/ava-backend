import { Module } from "@nestjs/common";
import { GraphQLModule } from "@nestjs/graphql";
import { CommandResolver } from "./command/command.resolver";
import { join } from "path";
import { CommandModule } from "./command/command.module";

@Module({
  imports: [
    CommandModule,
    GraphQLModule.forRoot({
      playground: true,
      autoSchemaFile: join(process.cwd(), "schema.gql"),
      sortSchema: true,
    }),
  ],
})
export class APIModule {}
