import 'package:postgres/postgres.dart';

import '../../coeur/base_de_donnees/connexion_postgresql.dart';
import '../../domaine/depots/depot_utilisateur.dart';
import '../../domaine/entites/utilisateur.dart';

class DepotUtilisateurPostgresql implements DepotUtilisateur {
  final ConnexionPostgresql _connexionPostgresql;

  DepotUtilisateurPostgresql({
    required ConnexionPostgresql connexionPostgresql,
  }) : _connexionPostgresql = connexionPostgresql;

  @override
  Future<Utilisateur?> obtenirParEmail(String email) async {
    final resultat = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT id, nom, email, mot_de_passe
        FROM utilisateurs
        WHERE email = @email
        ''',
      ),
      parameters: {
        'email': email,
      },
    );

    if (resultat.isEmpty) {
      return null;
    }

    final ligne = resultat.first;

    return Utilisateur(
      id: ligne[0] as String,
      nom: ligne[1] as String,
      email: ligne[2] as String,
      motDePasse: ligne[3] as String,
    );
  }

  @override
  Future<Utilisateur> creer(Utilisateur utilisateur) async {
    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        INSERT INTO utilisateurs (
          id,
          nom,
          email,
          mot_de_passe
        )
        VALUES (
          @id,
          @nom,
          @email,
          @motDePasse
        )
        ''',
      ),
      parameters: {
        'id': utilisateur.id,
        'nom': utilisateur.nom,
        'email': utilisateur.email,
        'motDePasse': utilisateur.motDePasse,
      },
    );

    return utilisateur;
  }
}