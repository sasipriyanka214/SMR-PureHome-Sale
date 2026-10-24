# my_api_server

[![style: dart frog lint][dart_frog_lint_badge]][dart_frog_lint_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dart-frog.dev)

An API server built with Dart Frog.

## API routes

- `GET /api/status` returns the API status and version.
- `POST /api/login` requires JSON containing non-empty `email` and `password`
  fields and returns the login template response.

The login route is currently a template and does not authenticate credentials.

[dart_frog_lint_badge]: https://img.shields.io/badge/style-dart_frog_lint-1DF9D2.svg
[dart_frog_lint_link]: https://pub.dev/packages/dart_frog_lint
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT