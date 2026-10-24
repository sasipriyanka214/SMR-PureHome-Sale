import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    return onPost(context);
  }

  return Response(statusCode: 405);
}

Future<Response> onPost(RequestContext context) async {
  dynamic data;
  try {
    data = await context.request.json();
  } on FormatException {
    return Response.json(
      statusCode: 400,
      body: {
        'status': 'error',
        'message': 'Invalid JSON request body',
      },
    );
  }

  if (data is! Map<String, dynamic>) {
    return Response.json(
      statusCode: 400,
      body: {
        'status': 'error',
        'message': 'Email and password are required',
      },
    );
  }

  final email = data['email'];
  final password = data['password'];
  if (email is! String ||
      email.isEmpty ||
      password is! String ||
      password.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {
        'status': 'error',
        'message': 'Email and password are required',
      },
    );
  }

  return Response.json(
    body: {
      'status': 'success',
      'message': 'API Login endpoint template ready',
    },
  );
}
