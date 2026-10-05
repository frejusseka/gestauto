import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/coeur/erreurs/identifiants_invalides_exception.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/connecter_utilisateur.dart';
import 'package:gestauto_backend/domaine/services/service_jeton.dart';
import 'package:gestauto_backend/domaine/services/service_mot_de_passe.dart';
import 'package:gestauto_backend/donnees/depots/depot_utilisateur_postgresql.dart';
import 'package:gestauto_backend/donnees/services/service_jeton_jwt.dart';
import 'package:gestauto_backend/donnees/services/service_mot_de_passe_bcrypt.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 405,
      body: {
        'message': 'Méthode HTTP non autorisée.',
      },
    );
  }

  try {
    final donnees = await context.request.json();

    if (donnees is! Map<String, dynamic>) {
      return Response.json(
        statusCode: 400,
        body: {
          'message': 'Le corps de la requête doit être un objet JSON.',
        },
      );
    }

    final email = donnees['email'] as String?;
    final motDePasse = donnees['motDePasse'] as String?;

    if (email == null || motDePasse == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Les champs email et motDePasse sont obligatoires.',
        },
      );
    }

    final secretJwt = Platform.environment['GESTAUTO_JWT_SECRET'];

    if (secretJwt == null || secretJwt.isEmpty) {
      throw StateError(
        'La variable d environnement GESTAUTO_JWT_SECRET est absente.',
      );
    }

    final depotUtilisateur =
        context.read<DepotUtilisateurPostgresql>();

    final ServiceMotDePasse serviceMotDePasse =
        ServiceMotDePasseBcrypt();

    final ServiceJeton serviceJeton = ServiceJetonJwt(
      secret: secretJwt,
    );

    final connecterUtilisateur = ConnecterUtilisateur(
      depot: depotUtilisateur,
      serviceMotDePasse: serviceMotDePasse,
      serviceJeton: serviceJeton,
    );

    final resultat = await connecterUtilisateur.executer(
      email: email,
      motDePasse: motDePasse,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Connexion réussie.',
        'utilisateur': {
          'id': resultat.utilisateur.id,
          'nom': resultat.utilisateur.nom,
          'email': resultat.utilisateur.email,
        },
        'jeton': resultat.jeton,
      },
    );
  } on IdentifiantsInvalidesException catch (erreur) {
    return Response.json(
      statusCode: 401,
      body: {
        'message': erreur.message,
      },
    );
  } catch (erreur) {
    return Response.json(
      statusCode: 500,
      body: {
        'message': 'Une erreur interne est survenue.',
      },
    );
  }
}