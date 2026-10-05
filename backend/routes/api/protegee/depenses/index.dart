import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/depense/creer_depense.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/depense/obtenir_depenses.dart';
import 'package:gestauto_backend/domaine/entites/depense.dart';
import 'package:gestauto_backend/donnees/depots/depot_depense_postgresql.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _obtenirDepenses(context);

    case HttpMethod.post:
      return _creerDepense(context);

    default:
      return Response.json(
        statusCode: 405,
        body: {
          'message': 'Méthode HTTP non autorisée.',
        },
      );
  }
}

Future<Response> _obtenirDepenses(
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

    final depotDepense =
        context.read<DepotDepensePostgresql>();

    final obtenirDepenses = ObtenirDepenses(
      depot: depotDepense,
    );

    final depenses = await obtenirDepenses.executer(
      utilisateurId: utilisateurId,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'depenses': depenses
            .map(_convertirDepenseEnJson)
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

Future<Response> _creerDepense(
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

    final dateDepense = DateTime.tryParse(date);

    if (dateDepense == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message': 'La date de la dépense est invalide.',
        },
      );
    }

    final depense = Depense(
      id: const Uuid().v4(),
      vehiculeId: vehiculeId,
      categorieId: categorieId,
      date: dateDepense,
      montant: montant,
      description: description,
    );

    final depotDepense =
        context.read<DepotDepensePostgresql>();

    final creerDepense = CreerDepense(
      depot: depotDepense,
    );

    final depenseCree =
        await creerDepense.executer(
      utilisateurId: utilisateurId,
      depense: depense,
    );

    return Response.json(
      statusCode: 201,
      body: {
        'message': 'Dépense créée avec succès.',
        'depense':
            _convertirDepenseEnJson(depenseCree),
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