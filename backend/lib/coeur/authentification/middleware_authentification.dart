import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../donnees/services/service_jeton_jwt.dart';
import 'authentification_jwt.dart';

Handler middleware(Handler handler) {
  final secretJwt =
      Platform.environment['GESTAUTO_JWT_SECRET'];

  return (context) async {
    if (secretJwt == null || secretJwt.isEmpty) {
      return Response.json(
        statusCode: 500,
        body: {
          'message':
              'La variable d environnement GESTAUTO_JWT_SECRET est absente.',
        },
      );
    }

    final authentification = AuthentificationJwt(
      serviceJeton: ServiceJetonJwt(
        secret: secretJwt,
      ),
    );

    final autorisation =
        context.request.headers['authorization'];

    if (autorisation == null) {
      return Response.json(
        statusCode: 401,
        body: {
          'message':
              'Jeton d authentification manquant.',
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
          'message':
              'Jeton d authentification vide.',
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
          'message':
              'Jeton d authentification invalide.',
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