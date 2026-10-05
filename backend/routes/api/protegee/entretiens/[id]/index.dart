import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/entretien/modifier_entretien.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/entretien/obtenir_entretien.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/entretien/supprimer_entretien.dart';
import 'package:gestauto_backend/domaine/entites/entretien.dart';
import 'package:gestauto_backend/donnees/depots/depot_entretien_postgresql.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _obtenirEntretien(
        context: context,
        entretienId: id,
      );

    case HttpMethod.put:
      return _modifierEntretien(
        context: context,
        entretienId: id,
      );

    case HttpMethod.delete:
      return _supprimerEntretien(
        context: context,
        entretienId: id,
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

Future<Response> _obtenirEntretien({
  required RequestContext context,
  required String entretienId,
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

    final depotEntretien =
        context.read<DepotEntretienPostgresql>();

    final obtenirEntretien = ObtenirEntretien(
      depot: depotEntretien,
    );

    final entretien = await obtenirEntretien.executer(
      utilisateurId: utilisateurId,
      entretienId: entretienId,
    );

    if (entretien == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Entretien introuvable.',
        },
      );
    }

    return Response.json(
      statusCode: 200,
      body: {
        'entretien':
            _convertirEntretienEnJson(entretien),
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

Future<Response> _modifierEntretien({
  required RequestContext context,
  required String entretienId,
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
    final type =
        donnees['type'] as String?;
    final date =
        donnees['date'] as String?;
    final kilometrage =
        (donnees['kilometrage'] as num?)?.toInt();
    final montant =
        (donnees['montant'] as num?)?.toDouble();
    final prochainKilometrage =
        (donnees['prochainKilometrage'] as num?)?.toInt();
    final prochaineDate =
        donnees['prochaineDate'] as String?;
    final notes =
        donnees['notes'] as String?;

    if (vehiculeId == null ||
        type == null ||
        date == null ||
        kilometrage == null ||
        montant == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Les champs vehiculeId, type, date, '
              'kilometrage et montant sont obligatoires.',
        },
      );
    }

    if (type.trim().isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {
          'message': 'Le type d’entretien est obligatoire.',
        },
      );
    }

    final dateEntretien = DateTime.tryParse(date);

    if (dateEntretien == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message': 'La date de l’entretien est invalide.',
        },
      );
    }

    DateTime? dateProchaine;

    if (prochaineDate != null) {
      dateProchaine = DateTime.tryParse(prochaineDate);

      if (dateProchaine == null) {
        return Response.json(
          statusCode: 400,
          body: {
            'message':
                'La prochaine date d’entretien est invalide.',
          },
        );
      }
    }

    final entretien = Entretien(
      id: entretienId,
      vehiculeId: vehiculeId,
      type: type.trim(),
      date: dateEntretien,
      kilometrage: kilometrage,
      montant: montant,
      prochainKilometrage: prochainKilometrage,
      prochaineDate: dateProchaine,
      notes: notes,
    );

    final depotEntretien =
        context.read<DepotEntretienPostgresql>();

    final modifierEntretien = ModifierEntretien(
      depot: depotEntretien,
    );

    final entretienModifie =
        await modifierEntretien.executer(
      utilisateurId: utilisateurId,
      entretien: entretien,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Entretien modifié avec succès.',
        'entretien':
            _convertirEntretienEnJson(entretienModifie),
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

Future<Response> _supprimerEntretien({
  required RequestContext context,
  required String entretienId,
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

    final depotEntretien =
        context.read<DepotEntretienPostgresql>();

    final obtenirEntretien = ObtenirEntretien(
      depot: depotEntretien,
    );

    final entretien = await obtenirEntretien.executer(
      utilisateurId: utilisateurId,
      entretienId: entretienId,
    );

    if (entretien == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Entretien introuvable.',
        },
      );
    }

    final supprimerEntretien = SupprimerEntretien(
      depot: depotEntretien,
    );

    await supprimerEntretien.executer(
      utilisateurId: utilisateurId,
      entretienId: entretienId,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Entretien supprimé avec succès.',
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

Map<String, dynamic> _convertirEntretienEnJson(
  Entretien entretien,
) {
  return {
    'id': entretien.id,
    'vehiculeId': entretien.vehiculeId,
    'type': entretien.type,
    'date': entretien.date.toIso8601String(),
    'kilometrage': entretien.kilometrage,
    'montant': entretien.montant,
    'prochainKilometrage':
        entretien.prochainKilometrage,
    'prochaineDate':
        entretien.prochaineDate?.toIso8601String(),
    'notes': entretien.notes,
  };
}