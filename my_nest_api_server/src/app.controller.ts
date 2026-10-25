import {
  Body,
  Controller,
  HttpException,
  HttpStatus,
  Get,
  Post,
} from '@nestjs/common';

@Controller('api')
export class AppController {
  @Get('status')
  getStatus(): {
    status: string;
    message: string;
    version: string;
  } {
    return {
      status: 'success',
      message: 'SMR PureHome API is running successfully with Supabase!',
      version: 'V18',
    };
  }

  @Post('login')
  login(@Body() body: unknown): {
    status: string;
    message: string;
  } {
    if (
      !isRecord(body) ||
      typeof body.email !== 'string' ||
      body.email.length === 0 ||
      typeof body.password !== 'string' ||
      body.password.length === 0
    ) {
      throw new HttpException(
        {
          status: 'error',
          message: 'Email and password are required',
        },
        HttpStatus.BAD_REQUEST,
      );
    }

    return {
      status: 'success',
      message: 'API Login endpoint template ready',
    };
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}
