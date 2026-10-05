import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/versement/modifier_versement.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/versement/obtenir_versement.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/versement/supprimer_versement.dart';
import 'package:gestauto_backend/domaine/entites/versement.dart';
import 'package:gestauto_backend/donnees/depots/depot_versement_postgresql.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _obtenirVersement(
        context: context,
        versementId: id,
      );

    case HttpMethod.put:
      return _modifierVersement(
        context: context,
        versementId: id,
      );

    case HttpMethod.delete:
      return _supprimerVersement(
        context: context,
        versementId: id,
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

Future<Response> _obtenirVersement({
  required RequestContext context,
  required String versementId,
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

    final depotVersement =
        context.read<DepotVersementPostgresql>();

    final obtenirVersement = ObtenirVersement(
      depot: depotVersement,
    );

    final versement = await obtenirVersement.executer(
      utilisateurId: utilisateurId,
      versementId: versementId,
    );

    if (versement == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Versement introuvable.',
        },
      );
    }

    return Response.json(
      statusCode: 200,
      body: {
        'versement':
            _convertirVersementEnJson(versement),
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

Future<Response> _modifierVersement({
  required RequestContext context,
  required String versementId,
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
      id: versementId,
      vehiculeId: vehiculeId,
      date: DateTime.parse(date),
      montantAttendu: montantAttendu,
      montantVerse: montantVerse,
    );

    final depotVersement =
        context.read<DepotVersementPostgresql>();

    final modifierVersement = ModifierVersement(
      depot: depotVersement,
    );

    final versementModifie =
        await modifierVersement.executer(
      utilisateurId: utilisateurId,
      versement: versement,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Versement modifié avec succès.',
        'versement':
            _convertirVersementEnJson(versementModifie),
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

Future<Response> _supprimerVersement({
  required RequestContext context,
  required String versementId,
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

    final depotVersement =
        context.read<DepotVersementPostgresql>();

    final obtenirVersement = ObtenirVersement(
      depot: depotVersement,
    );

    final versement = await obtenirVersement.executer(
      utilisateurId: utilisateurId,
      versementId: versementId,
    );

    if (versement == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Versement introuvable.',
        },
      );
    }

    final supprimerVersement = SupprimerVersement(
      depot: depotVersement,
    );

    await supprimerVersement.executer(
      utilisateurId: utilisateurId,
      versementId: versementId,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Versement supprimé avec succès.',
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