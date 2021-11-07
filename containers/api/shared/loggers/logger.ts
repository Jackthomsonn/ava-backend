import { LoggerService, LogLevel } from "@nestjs/common";

export class AvaLogger implements LoggerService {
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