import { CanActivate, ExecutionContext, Injectable } from "@nestjs/common";
import { GqlExecutionContext } from "@nestjs/graphql";
import { JwtHeader, verify, VerifyOptions } from "jsonwebtoken";
import * as jwksClient from "jwks-rsa";

type AuthOptions = {
  permissions: string[];
  checkEveryPermission?: boolean;
};

export const AuthGuard = (options: AuthOptions) => {
  return new AuthGuardImpl(options);
};

@Injectable()
class AuthGuardImpl implements CanActivate {
  constructor(private options: AuthOptions) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const ctx = GqlExecutionContext.create(context);
    const request = ctx.getContext().request;
    const token = request.get("Authorization");

    try {
      const isValid = await this.verify(token);

      return isValid;
    } catch {
      return false;
    }
  }

  private getKey(header: JwtHeader, callback: Function) {
    jwksClient({
      jwksUri: process.env.JWKS_URI,
    }).getSigningKey(header.kid, (_error, key) => {
      const signingKey = key.getPublicKey();

      callback(null, signingKey);
    });
  }

  private checkPermissions(decoded: any) {
    const matches = this.options.permissions.map((permission) =>
      decoded.permissions.includes(permission)
    );

    return this.options.checkEveryPermission
      ? matches.every((m) => m)
      : matches.some((m) => m);
  }

  private verify = (token: string): Promise<boolean> => {
    return new Promise((resolve) => {
      const options: VerifyOptions = {
        audience: process.env.AUDIENCE,
        issuer: process.env.ISSUER,
        algorithms: ["RS256"],
      };

      verify(token, this.getKey, options, (err, decoded) => {
        if (err) {
          return resolve(false);
        } else {
          if (this.options.permissions.length) {
            if (this.checkPermissions(decoded)) {
              return resolve(true);
            }
            return resolve(false);
          } else {
            return resolve(true);
          }
        }
      });
    });
  };
}
