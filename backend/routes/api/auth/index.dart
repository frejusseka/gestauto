import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.json(
    body: {
      'module': 'authentification',
      'message': 'Module d authentification GESTAUTO opérationnel',
    },
  );
}