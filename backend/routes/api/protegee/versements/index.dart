import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/versement/creer_versement.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/versement/obtenir_versements.dart';
import 'package:gestauto_backend/domaine/entites/versement.dart';
import 'package:gestauto_backend/donnees/depots/depot_versement_postgresql.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _obtenirVersements(context);

    case HttpMethod.post:
      return _creerVersement(context);

    default:
      return Response.json(
        statusCode: 405,
        body: {
          'message': 'Méthode HTTP non autorisée.',
        },
      );
  }
}

Future<Response> _obtenirVersements(
  RequestContext context,
) async {
  try {
    final utilisateurId =
        context.read<Map<String, dynamic>>()['utilisateurId']
            as String?;

    if (utilisateurId == null || utilisateurId.isEmpty) {
      return Response.json(
        statusCode: 401,
        body: {
          'message': 'Utilisateur authentifié introuvable.',
        },
      );
    }

    final depotVersement =
        context.read<DepotVersementPostgresql>();

    final obtenirVersements = ObtenirVersements(
      depot: depotVersement,
    );

    final versements = await obtenirVersements.executer(
      utilisateurId: utilisateurId,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'versements': versements.map(
          _convertirVersementEnJson,
        ).toList(),
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

Future<Response> _creerVersement(
  RequestContext context,
) async {
  try {
    final donnees = await context.request.json();

    if (donnees is! Map<String, dynamic>) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Le corps de la requête doit être un objet JSON.',
        },
      );
    }

    final utilisateurId =
        context.read<Map<String, dynamic>>()['utilisateurId']
            as String?;

    if (utilisateurId == null || utilisateurId.isEmpty) {
      return Response.json(
        statusCode: 401,
        body: {
          'message': 'Utilisateur authentifié introuvable.',
        },
      );
    }

    final vehiculeId =
        donnees['vehiculeId'] as String?;
    final date =
        donnees['date'] as String?;
    final montantAttendu =
        (donnees['montantAttendu'] as num?)?.toDouble();
    final montantVerse =
        (donnees['montantVerse'] as num?)?.toDouble();

    if (vehiculeId == null ||
        date == null ||
        montantAttendu == null ||
        montantVerse == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Les champs vehiculeId, date, montantAttendu '
              'et montantVerse sont obligatoires.',
        },
      );
    }

    final versement = Versement(
      id: const Uuid().v4(),
      vehiculeId: vehiculeId,
      date: DateTime.parse(date),
      montantAttendu: montantAttendu,
      montantVerse: montantVerse,
    );

    final depotVersement =
        context.read<DepotVersementPostgresql>();

    final creerVersement = CreerVersement(
      depot: depotVersement,
    );

    final versementCree =
        await creerVersement.executer(
      utilisateurId: utilisateurId,
      versement: versement,
    );

    return Response.json(
      statusCode: 201,
      body: {
        'message': 'Versement créé avec succès.',
        'versement':
            _convertirVersementEnJson(versementCree),
      },
    );
  } on FormatException {
    return Response.json(
      statusCode: 400,
      body: {
        'message': 'La date du versement est invalide.',
      },
    );
  } on StateError catch (erreur) {
    return Response.json(
      statusCode: 404,
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

Map<String, dynamic> _convertirVersementEnJson(
  Versement versement,
) {
  return {
    'id': versement.id,
    'vehiculeId': versement.vehiculeId,
    'date': versement.date.toIso8601String(),
    'montantAttendu': versement.montantAttendu,
    'montantVerse': versement.montantVerse,
    'ecart': versement.ecart,
    'statut': versement.statut.name,
  };
}