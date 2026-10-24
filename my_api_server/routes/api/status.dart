import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  if (context.request.method == HttpMethod.get) {
    return onGet(context);
  }

  return Response(statusCode: 405);
}

Response onGet(RequestContext context) {
  return Response.json(
    body: {
      'status': 'success',
      'message': 'SMR PureHome API is running successfully with Supabase!',
      'version': 'V18',
    },
  );
}
