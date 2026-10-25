import { HttpException, HttpStatus } from '@nestjs/common';
import { AppController } from './app.controller';

describe('AppController', () => {
  const controller = new AppController();

  describe('getStatus', () => {
    it('returns the API status and version', () => {
      expect(controller.getStatus()).toEqual({
        status: 'success',
        message: 'SMR PureHome API is running successfully with Supabase!',
        version: 'V18',
      });
    });
  });

  describe('login', () => {
    it('rejects missing credentials with a 400 error', () => {
      try {
        controller.login({ email: 'user@example.com' });
        fail('Expected login to reject missing credentials');
      } catch (error) {
        expect(error).toBeInstanceOf(HttpException);
        expect((error as HttpException).getStatus()).toBe(
          HttpStatus.BAD_REQUEST,
        );
        expect((error as HttpException).getResponse()).toEqual({
          status: 'error',
          message: 'Email and password are required',
        });
      }
    });

    it('returns the template response when credentials are present', () => {
      expect(
        controller.login({
          email: 'user@example.com',
          password: 'secret',
        }),
      ).toEqual({
        status: 'success',
        message: 'API Login endpoint template ready',
      });
    });
  });
});
