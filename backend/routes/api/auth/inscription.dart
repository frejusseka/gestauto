import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/coeur/erreurs/email_deja_utilise_exception.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/inscrire_utilisateur.dart';
import 'package:gestauto_backend/domaine/services/service_mot_de_passe.dart';
import 'package:gestauto_backend/donnees/depots/depot_categorie_depense_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_utilisateur_postgresql.dart';
import 'package:gestauto_backend/donnees/services/service_mot_de_passe_bcrypt.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

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
          'message':
              'Le corps de la requête doit être un objet JSON.',
        },
      );
    }

    final nom = donnees['nom'] as String?;
    final email = donnees['email'] as String?;
    final motDePasse =
        donnees['motDePasse'] as String?;

    if (nom == null ||
        email == null ||
        motDePasse == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Les champs nom, email et motDePasse sont obligatoires.',
        },
      );
    }

    final depotUtilisateur =
        context.read<DepotUtilisateurPostgresql>();

    final depotCategorieDepense =
        context.read<
            DepotCategorieDepensePostgresql>();

    final ServiceMotDePasse serviceMotDePasse =
        ServiceMotDePasseBcrypt();

    final inscrireUtilisateur =
        InscrireUtilisateur(
      depot: depotUtilisateur,
      depotCategorieDepense:
          depotCategorieDepense,
      serviceMotDePasse:
          serviceMotDePasse,
    );

    final utilisateur =
        await inscrireUtilisateur.executer(
      id: _uuid.v4(),
      nom: nom,
      email: email,
      motDePasse: motDePasse,
    );

    return Response.json(
      statusCode: 201,
      body: {
        'message': 'Inscription réussie.',
        'utilisateur': {
          'id': utilisateur.id,
          'nom': utilisateur.nom,
          'email': utilisateur.email,
        },
      },
    );
  } on EmailDejaUtiliseException catch (erreur) {
    return Response.json(
      statusCode: 409,
      body: {
        'message': erreur.message,
      },
    );
  } catch (erreur) {
    return Response.json(
      statusCode: 500,
      body: {
        'message':
            'Une erreur interne est survenue.',
      },
    );
  }
}