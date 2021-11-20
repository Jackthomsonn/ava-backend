import { LoggerService, LogLevel } from "@nestjs/common";

export class AvaLogger implements LoggerService {
  private logLevels: LogLevel[];

  log(message: any, ...optionalParams: any[]) {
    if (this.logLevels.includes("log")) {
      console.log(`[ava:log] - ${message}`);
    }
  }

  error(message: any, ...optionalParams: any[]) {
    if (this.logLevels.includes("error")) {
      console.log(`[ava:error] - ${message}`);
    }
  }

  warn(message: any, ...optionalParams: any[]) {
    if (this.logLevels.includes("warn")) {
      console.log(`[ava:warn] - ${message}`);
    }
  }

  debug(message: any, ...optionalParams: any[]) {
    if (this.logLevels.includes("debug")) {
      console.log(`[ava:debug] - ${message}`);
    }
  }

  verbose(message: any, ...optionalParams: any[]) {
    if (this.logLevels.includes("verbose")) {
      console.log(`[ava:verbose] - ${message}`);
    }
  }

  setLogLevels(levels: LogLevel[]) {
    this.logLevels = levels;
  }
}
