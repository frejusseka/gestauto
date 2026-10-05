import 'package:test/test.dart';

import 'package:gestauto_backend/coeur/base_de_donnees/connexion_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_utilisateur_postgresql.dart';
import 'package:gestauto_backend/domaine/entites/utilisateur.dart';

void main() {
  late ConnexionPostgresql connexionPostgresql;
  late DepotUtilisateurPostgresql depot;

  setUpAll(() async {
    connexionPostgresql = ConnexionPostgresql();

    await connexionPostgresql.ouvrir();

    depot = DepotUtilisateurPostgresql(
      connexionPostgresql: connexionPostgresql,
    );
  });

  tearDownAll(() async {
    await connexionPostgresql.fermer();
  });

  test('crée puis retrouve un utilisateur dans PostgreSQL', () async {
    final utilisateur = Utilisateur(
      id: '22222222-2222-2222-2222-222222222222',
      nom: 'Utilisateur Test',
      email:
          'test-depot-postgresql-${DateTime.now().microsecondsSinceEpoch}@test.com',
      motDePasse: 'mot-de-passe-hache',
    );

    await depot.creer(utilisateur);

    final utilisateurRetrouve =
        await depot.obtenirParEmail(utilisateur.email);

    expect(utilisateurRetrouve, isNotNull);
    expect(utilisateurRetrouve!.id, utilisateur.id);
    expect(utilisateurRetrouve.nom, utilisateur.nom);
    expect(utilisateurRetrouve.email, utilisateur.email);
    expect(utilisateurRetrouve.motDePasse, utilisateur.motDePasse);
  });
}