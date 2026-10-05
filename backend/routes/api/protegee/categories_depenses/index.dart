import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/categorie_depense/creer_categorie_depense.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/categorie_depense/obtenir_categories_depense.dart';
import 'package:gestauto_backend/domaine/entites/categorie_depense.dart';
import 'package:gestauto_backend/donnees/depots/depot_categorie_depense_postgresql.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _obtenirCategories(context);

    case HttpMethod.post:
      return _creerCategorie(context);

    default:
      return Response.json(
        statusCode: 405,
        body: {
          'message': 'Méthode HTTP non autorisée.',
        },
      );
  }
}

Future<Response> _obtenirCategories(
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

    final depotCategorie =
        context.read<DepotCategorieDepensePostgresql>();

    final obtenirCategories =
        ObtenirCategoriesDepense(
      depot: depotCategorie,
    );

    final categories =
        await obtenirCategories.executer(
      utilisateurId: utilisateurId,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'categories': categories
            .map(_convertirCategorieEnJson)
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

Future<Response> _creerCategorie(
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
      id: const Uuid().v4(),
      utilisateurId: utilisateurId,
      nom: nom.trim(),
    );

    final depotCategorie =
        context.read<DepotCategorieDepensePostgresql>();

    final creerCategorie =
        CreerCategorieDepense(
      depot: depotCategorie,
    );

    final categorieCree =
        await creerCategorie.executer(
      categorie: categorie,
    );

    return Response.json(
      statusCode: 201,
      body: {
        'message':
            'Catégorie de dépense créée avec succès.',
        'categorie':
            _convertirCategorieEnJson(categorieCree),
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