# SMR PureHome NestJS API

NestJS implementation of the API endpoints, maintained separately from the
Dart Frog server in `my_api_server`.

## Routes

- `GET /api/status` returns the API status and V18 version.
- `POST /api/login` expects a JSON object with non-empty `email` and `password`
  strings. It currently returns a template response and does not authenticate
  credentials.

## Run

Requires Node.js 20 or later.

```sh
npm install
npm run start:dev
```

The server listens on port 3000 by default. Set `PORT` to use a different port.
