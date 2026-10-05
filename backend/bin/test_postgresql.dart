import 'package:gestauto_backend/coeur/base_de_donnees/connexion_postgresql.dart';

Future<void> main() async {
  final connexion = ConnexionPostgresql();

  try {
    await connexion.ouvrir();

    final resultat = await connexion.connexion.execute(
      'SELECT current_database(), current_user;',
    );

    print('Connexion PostgreSQL réussie.');
    print(resultat);
  } catch (erreur) {
    print('Échec de la connexion PostgreSQL.');
    print(erreur);
  } finally {
    await connexion.fermer();
  }
}