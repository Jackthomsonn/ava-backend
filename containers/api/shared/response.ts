import { Field, ObjectType } from "@nestjs/graphql";

@ObjectType()
export class CreationResponse {
  @Field(() => Boolean, {
    description: "Determines if the request was successful",
  })
  public success: boolean;
}
