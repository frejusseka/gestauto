import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  final donneesUtilisateur =
      context.read<Map<String, dynamic>>();

  return Response.json(
    body: {
      'message': 'Accès à la route protégée autorisé.',
      'utilisateurId': donneesUtilisateur['utilisateurId'],
      'email': donneesUtilisateur['email'],
    },
  );
}