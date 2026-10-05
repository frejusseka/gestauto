import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/depense/modifier_depense.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/depense/obtenir_depense.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/depense/supprimer_depense.dart';
import 'package:gestauto_backend/domaine/entites/depense.dart';
import 'package:gestauto_backend/donnees/depots/depot_depense_postgresql.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _obtenirDepense(
        context: context,
        depenseId: id,
      );

    case HttpMethod.put:
      return _modifierDepense(
        context: context,
        depenseId: id,
      );

    case HttpMethod.delete:
      return _supprimerDepense(
        context: context,
        depenseId: id,
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

Future<Response> _obtenirDepense({
  required RequestContext context,
  required String depenseId,
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

    final depotDepense =
        context.read<DepotDepensePostgresql>();

    final obtenirDepense = ObtenirDepense(
      depot: depotDepense,
    );

    final depense = await obtenirDepense.executer(
      utilisateurId: utilisateurId,
      depenseId: depenseId,
    );

    if (depense == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Dépense introuvable.',
        },
      );
    }

    return Response.json(
      statusCode: 200,
      body: {
        'depense': _convertirDepenseEnJson(depense),
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

Future<Response> _modifierDepense({
  required RequestContext context,
  required String depenseId,
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
    final categorieId =
        donnees['categorieId'] as String?;
    final date =
        donnees['date'] as String?;
    final montant =
        (donnees['montant'] as num?)?.toDouble();
    final description =
        donnees['description'] as String?;

    if (vehiculeId == null ||
        categorieId == null ||
        date == null ||
        montant == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Les champs vehiculeId, categorieId, date '
              'et montant sont obligatoires.',
        },
      );
    }

    final depense = Depense(
      id: depenseId,
      vehiculeId: vehiculeId,
      categorieId: categorieId,
      date: DateTime.parse(date),
      montant: montant,
      description: description,
    );

    final depotDepense =
        context.read<DepotDepensePostgresql>();

    final modifierDepense = ModifierDepense(
      depot: depotDepense,
    );

    final depenseModifiee =
        await modifierDepense.executer(
      utilisateurId: utilisateurId,
      depense: depense,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Dépense modifiée avec succès.',
        'depense':
            _convertirDepenseEnJson(depenseModifiee),
      },
    );
  } on FormatException {
    return Response.json(
      statusCode: 400,
      body: {
        'message': 'La date de la dépense est invalide.',
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

Future<Response> _supprimerDepense({
  required RequestContext context,
  required String depenseId,
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

    final depotDepense =
        context.read<DepotDepensePostgresql>();

    final obtenirDepense = ObtenirDepense(
      depot: depotDepense,
    );

    final depense = await obtenirDepense.executer(
      utilisateurId: utilisateurId,
      depenseId: depenseId,
    );

    if (depense == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Dépense introuvable.',
        },
      );
    }

    final supprimerDepense = SupprimerDepense(
      depot: depotDepense,
    );

    await supprimerDepense.executer(
      utilisateurId: utilisateurId,
      depenseId: depenseId,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Dépense supprimée avec succès.',
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

Map<String, dynamic> _convertirDepenseEnJson(
  Depense depense,
) {
  return {
    'id': depense.id,
    'vehiculeId': depense.vehiculeId,
    'categorieId': depense.categorieId,
    'date': depense.date.toIso8601String(),
    'montant': depense.montant,
    'description': depense.description,
  };
}