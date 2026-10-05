import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/categorie_depense/modifier_categorie_depense.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/categorie_depense/obtenir_categorie_depense.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/categorie_depense/supprimer_categorie_depense.dart';
import 'package:gestauto_backend/domaine/entites/categorie_depense.dart';
import 'package:gestauto_backend/donnees/depots/depot_categorie_depense_postgresql.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _obtenirCategorie(
        context: context,
        categorieId: id,
      );

    case HttpMethod.put:
      return _modifierCategorie(
        context: context,
        categorieId: id,
      );

    case HttpMethod.delete:
      return _supprimerCategorie(
        context: context,
        categorieId: id,
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

Future<Response> _obtenirCategorie({
  required RequestContext context,
  required String categorieId,
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

    final depotCategorie =
        context.read<DepotCategorieDepensePostgresql>();

    final obtenirCategorie =
        ObtenirCategorieDepense(
      depot: depotCategorie,
    );

    final categorie =
        await obtenirCategorie.executer(
      utilisateurId: utilisateurId,
      categorieId: categorieId,
    );

    if (categorie == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Catégorie de dépense introuvable.',
        },
      );
    }

    return Response.json(
      statusCode: 200,
      body: {
        'categorie':
            _convertirCategorieEnJson(categorie),
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

Future<Response> _modifierCategorie({
  required RequestContext context,
  required String categorieId,
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

    final nom = donnees['nom'] as String?;

    if (nom == null || nom.trim().isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Le nom de la catégorie est obligatoire.',
        },
      );
    }

    final categorie = CategorieDepense(
      id: categorieId,
      utilisateurId: utilisateurId,
      nom: nom.trim(),
    );

    final depotCategorie =
        context.read<DepotCategorieDepensePostgresql>();

    final modifierCategorie =
        ModifierCategorieDepense(
      depot: depotCategorie,
    );

    final categorieModifiee =
        await modifierCategorie.executer(
      categorie: categorie,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message':
            'Catégorie de dépense modifiée avec succès.',
        'categorie':
            _convertirCategorieEnJson(categorieModifiee),
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

Future<Response> _supprimerCategorie({
  required RequestContext context,
  required String categorieId,
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

    final depotCategorie =
        context.read<DepotCategorieDepensePostgresql>();

    final obtenirCategorie =
        ObtenirCategorieDepense(
      depot: depotCategorie,
    );

    final categorie =
        await obtenirCategorie.executer(
      utilisateurId: utilisateurId,
      categorieId: categorieId,
    );

    if (categorie == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Catégorie de dépense introuvable.',
        },
      );
    }

    final supprimerCategorie =
        SupprimerCategorieDepense(
      depot: depotCategorie,
    );

    await supprimerCategorie.executer(
      utilisateurId: utilisateurId,
      categorieId: categorieId,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message':
            'Catégorie de dépense supprimée avec succès.',
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

Map<String, dynamic> _convertirCategorieEnJson(
  CategorieDepense categorie,
) {
  return {
    'id': categorie.id,
    'utilisateurId': categorie.utilisateurId,
    'nom': categorie.nom,
  };
}