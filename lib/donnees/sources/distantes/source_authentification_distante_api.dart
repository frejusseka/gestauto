import 'package:dio/dio.dart';

import '../../../domaine/depots/depot_authentification.dart';
import '../../../domaine/entites/utilisateur.dart';

class SourceAuthentificationDistanteApi {
  final Dio _dio;

  SourceAuthentificationDistanteApi({
    required this._dio,
  });

  Future<ResultatAuthentification> connecter({
    required String email,
    required String motDePasse,
  }) async {
    final reponse = await _dio.post(
      '/auth/connexion',
      data: {
        'email': email,
        'motDePasse': motDePasse,
      },
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    final utilisateurJson =
        donnees['utilisateur'] as Map<String, dynamic>;

    final utilisateur = Utilisateur(
      id: utilisateurJson['id'] as String,
      nom: utilisateurJson['nom'] as String,
      email: utilisateurJson['email'] as String,
    );

    return ResultatAuthentification(
      utilisateur: utilisateur,
      jeton: donnees['jeton'] as String,
    );
  }

  Future<Utilisateur> inscrire({
    required String nom,
    required String email,
    required String motDePasse,
  }) async {
    final reponse = await _dio.post(
      '/auth/inscription',
      data: {
        'nom': nom,
        'email': email,
        'motDePasse': motDePasse,
      },
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    return Utilisateur(
      id: donnees['id'] as String,
      nom: donnees['nom'] as String,
      email: donnees['email'] as String,
    );
  }

  Future<void> deconnecter() async {
    // La déconnexion sera gérée localement
    // lorsque nous aurons mis en place le stockage
    // du JWT.
  }
}