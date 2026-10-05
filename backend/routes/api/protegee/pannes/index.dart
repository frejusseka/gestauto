import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/panne/creer_panne.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/panne/obtenir_pannes.dart';
import 'package:gestauto_backend/domaine/entites/panne.dart';
import 'package:gestauto_backend/donnees/depots/depot_panne_postgresql.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _obtenirPannes(context);

    case HttpMethod.post:
      return _creerPanne(context);

    default:
      return Response.json(
        statusCode: 405,
        body: {
          'message': 'Méthode HTTP non autorisée.',
        },
      );
  }
}

Future<Response> _obtenirPannes(
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

    final depotPanne =
        context.read<DepotPannePostgresql>();

    final obtenirPannes = ObtenirPannes(
      depot: depotPanne,
    );

    final pannes = await obtenirPannes.executer(
      utilisateurId: utilisateurId,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'pannes': pannes
            .map(_convertirPanneEnJson)
            .toList(),
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

Future<Response> _creerPanne(
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
    final description =
        donnees['description'] as String?;
    final gravite =
        donnees['gravite'] as String?;
    final resolue =
        donnees['resolue'] as bool?;
    final dateResolution =
        donnees['dateResolution'] as String?;

    if (vehiculeId == null ||
        date == null ||
        description == null ||
        gravite == null ||
        resolue == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Les champs vehiculeId, date, description, '
              'gravite et resolue sont obligatoires.',
        },
      );
    }

    if (description.trim().isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {
          'message': 'La description de la panne est obligatoire.',
        },
      );
    }

    final datePanne = DateTime.tryParse(date);

    if (datePanne == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message': 'La date de la panne est invalide.',
        },
      );
    }

    DateTime? dateResolutionPanne;

    if (dateResolution != null) {
      dateResolutionPanne =
          DateTime.tryParse(dateResolution);

      if (dateResolutionPanne == null) {
        return Response.json(
          statusCode: 400,
          body: {
            'message':
                'La date de résolution de la panne est invalide.',
          },
        );
      }
    }

    late final GravitePanne gravitePanne;

    try {
      gravitePanne = GravitePanne.values.byName(gravite);
    } on ArgumentError {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'La gravité doit être faible, moyenne ou grave.',
        },
      );
    }

    if (resolue && dateResolutionPanne == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Une panne résolue doit avoir une date de résolution.',
        },
      );
    }

    if (!resolue && dateResolutionPanne != null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Une panne non résolue ne doit pas avoir de date '
              'de résolution.',
        },
      );
    }

    final panne = Panne(
      id: const Uuid().v4(),
      vehiculeId: vehiculeId,
      date: datePanne,
      description: description.trim(),
      gravite: gravitePanne,
      resolue: resolue,
      dateResolution: dateResolutionPanne,
    );

    final depotPanne =
        context.read<DepotPannePostgresql>();

    final creerPanne = CreerPanne(
      depot: depotPanne,
    );

    final panneCreee = await creerPanne.executer(
      utilisateurId: utilisateurId,
      panne: panne,
    );

    return Response.json(
      statusCode: 201,
      body: {
        'message': 'Panne créée avec succès.',
        'panne': _convertirPanneEnJson(panneCreee),
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

Map<String, dynamic> _convertirPanneEnJson(
  Panne panne,
) {
  return {
    'id': panne.id,
    'vehiculeId': panne.vehiculeId,
    'date': panne.date.toIso8601String(),
    'description': panne.description,
    'gravite': panne.gravite.name,
    'resolue': panne.resolue,
    'dateResolution':
        panne.dateResolution?.toIso8601String(),
  };
}