import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/panne/modifier_panne.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/panne/obtenir_panne.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/panne/supprimer_panne.dart';
import 'package:gestauto_backend/domaine/entites/panne.dart';
import 'package:gestauto_backend/donnees/depots/depot_panne_postgresql.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _obtenirPanne(
        context: context,
        panneId: id,
      );

    case HttpMethod.put:
      return _modifierPanne(
        context: context,
        panneId: id,
      );

    case HttpMethod.delete:
      return _supprimerPanne(
        context: context,
        panneId: id,
      );

    default:
      return Response.json(
        statusCode: 405,
        body: {
          'message': 'Méthode HTTP non autorisée.',
        },
      );
  }
}

Future<Response> _obtenirPanne({
  required RequestContext context,
  required String panneId,
}) async {
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

    final obtenirPanne = ObtenirPanne(
      depot: depotPanne,
    );

    final panne = await obtenirPanne.executer(
      utilisateurId: utilisateurId,
      panneId: panneId,
    );

    if (panne == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Panne introuvable.',
        },
      );
    }

    return Response.json(
      statusCode: 200,
      body: {
        'panne': _convertirPanneEnJson(panne),
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

Future<Response> _modifierPanne({
  required RequestContext context,
  required String panneId,
}) async {
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
      id: panneId,
      vehiculeId: vehiculeId,
      date: datePanne,
      description: description.trim(),
      gravite: gravitePanne,
      resolue: resolue,
      dateResolution: dateResolutionPanne,
    );

    final depotPanne =
        context.read<DepotPannePostgresql>();

    final modifierPanne = ModifierPanne(
      depot: depotPanne,
    );

    final panneModifiee =
        await modifierPanne.executer(
      utilisateurId: utilisateurId,
      panne: panne,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Panne modifiée avec succès.',
        'panne': _convertirPanneEnJson(panneModifiee),
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

Future<Response> _supprimerPanne({
  required RequestContext context,
  required String panneId,
}) async {
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

    final obtenirPanne = ObtenirPanne(
      depot: depotPanne,
    );

    final panne = await obtenirPanne.executer(
      utilisateurId: utilisateurId,
      panneId: panneId,
    );

    if (panne == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Panne introuvable.',
        },
      );
    }

    final supprimerPanne = SupprimerPanne(
      depot: depotPanne,
    );

    await supprimerPanne.executer(
      utilisateurId: utilisateurId,
      panneId: panneId,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Panne supprimée avec succès.',
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