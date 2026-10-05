import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.json(
    body: {
      'application': 'GESTAUTO',
      'message': 'API GESTAUTO opérationnelle',
    },
  );
}