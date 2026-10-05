import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../lib/coeur/authentification/authentification_jwt.dart';
import '../../../lib/donnees/services/service_jeton_jwt.dart';

Handler middleware(Handler handler) {
  final secretJwt = Platform.environment['GESTAUTO_JWT_SECRET'];

  if (secretJwt == null || secretJwt.isEmpty) {
    throw StateError(
      'La variable d environnement GESTAUTO_JWT_SECRET est absente.',
    );
  }

  final authentification = AuthentificationJwt(
    serviceJeton: ServiceJetonJwt(
      secret: secretJwt,
    ),
  );

  return (context) async {
    final autorisation =
        context.request.headers['authorization'];

    if (autorisation == null) {
      return Response.json(
        statusCode: 401,
        body: {
          'message': 'Jeton d authentification manquant.',
        },
      );
    }

    if (!autorisation.startsWith('Bearer ')) {
      return Response.json(
        statusCode: 401,
        body: {
          'message':
              'Format du jeton d authentification invalide.',
        },
      );
    }

    final jeton = autorisation.substring(7);

    if (jeton.isEmpty) {
      return Response.json(
        statusCode: 401,
        body: {
          'message': 'Jeton d authentification vide.',
        },
      );
    }

    Map<String, dynamic> donnees;

    try {
      donnees =
          authentification.authentifier(jeton);
    } catch (erreur) {
      return Response.json(
        statusCode: 401,
        body: {
          'message': 'Jeton d authentification invalide.',
        },
      );
    }

    return handler(
      context.provide<Map<String, dynamic>>(
        () => donnees,
      ),
    );
  };
}