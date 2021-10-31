import { Injectable } from '@nestjs/common';

@Injectable()
export class CommandService {
  getHello(): string {
    return 'Hello World 2!';
  }
}
