import 'package:postgres/postgres.dart';

import '../../coeur/base_de_donnees/connexion_postgresql.dart';
import '../../domaine/depots/depot_categorie_depense.dart';
import '../../domaine/entites/categorie_depense.dart';

class DepotCategorieDepensePostgresql
    implements DepotCategorieDepense {
  final ConnexionPostgresql _connexionPostgresql;

  DepotCategorieDepensePostgresql({
    required ConnexionPostgresql connexionPostgresql,
  }) : _connexionPostgresql = connexionPostgresql;

  @override
  Future<List<CategorieDepense>> obtenirTous({
    required String utilisateurId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          id,
          utilisateur_id,
          nom
        FROM categories_depenses
        WHERE utilisateur_id = @utilisateurId
        ORDER BY nom
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
      },
    );

    return resultat
        .map(_convertirLigneEnCategorie)
        .toList();
  }

  @override
  Future<CategorieDepense?> obtenirParId({
    required String utilisateurId,
    required String categorieId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          id,
          utilisateur_id,
          nom
        FROM categories_depenses
        WHERE id = @categorieId
          AND utilisateur_id = @utilisateurId
        ''',
      ),
      parameters: {
        'categorieId': categorieId,
        'utilisateurId': utilisateurId,
      },
    );

    if (resultat.isEmpty) {
      return null;
    }

    return _convertirLigneEnCategorie(resultat.first);
  }

  @override
  Future<CategorieDepense> creer({
    required CategorieDepense categorie,
  }) async {
    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        INSERT INTO categories_depenses (
          id,
          utilisateur_id,
          nom
        )
        VALUES (
          @id,
          @utilisateurId,
          @nom
        )
        ''',
      ),
      parameters: {
        'id': categorie.id,
        'utilisateurId': categorie.utilisateurId,
        'nom': categorie.nom,
      },
    );

    return categorie;
  }

  @override
  Future<CategorieDepense> modifier({
    required CategorieDepense categorie,
  }) async {
    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        UPDATE categories_depenses
        SET nom = @nom
        WHERE id = @id
          AND utilisateur_id = @utilisateurId
        ''',
      ),
      parameters: {
        'id': categorie.id,
        'utilisateurId': categorie.utilisateurId,
        'nom': categorie.nom,
      },
    );

    return categorie;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String categorieId,
  }) async {
    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM categories_depenses
        WHERE id = @categorieId
          AND utilisateur_id = @utilisateurId
        ''',
      ),
      parameters: {
        'categorieId': categorieId,
        'utilisateurId': utilisateurId,
      },
    );
  }

  CategorieDepense _convertirLigneEnCategorie(
    ResultRow ligne,
  ) {
    return CategorieDepense(
      id: ligne[0] as String,
      utilisateurId: ligne[1] as String,
      nom: ligne[2] as String,
    );
  }
}