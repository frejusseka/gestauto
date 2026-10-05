import 'package:postgres/postgres.dart';

import '../../coeur/base_de_donnees/connexion_postgresql.dart';
import '../../domaine/depots/depot_depense.dart';
import '../../domaine/entites/depense.dart';

class DepotDepensePostgresql implements DepotDepense {
  final ConnexionPostgresql _connexionPostgresql;

  DepotDepensePostgresql({
    required ConnexionPostgresql connexionPostgresql,
  }) : _connexionPostgresql = connexionPostgresql;

  @override
  Future<List<Depense>> obtenirTous({
    required String utilisateurId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          d.id,
          d.vehicule_id,
          d.categorie_id,
          d.date,
          d.montant,
          d.description
        FROM depenses d
        INNER JOIN vehicules v
          ON v.id = d.vehicule_id
        WHERE v.utilisateur_id = @utilisateurId
        ORDER BY d.date DESC
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
      },
    );

    return resultat
        .map(_convertirLigneEnDepense)
        .toList();
  }

  @override
  Future<List<Depense>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          d.id,
          d.vehicule_id,
          d.categorie_id,
          d.date,
          d.montant,
          d.description
        FROM depenses d
        INNER JOIN vehicules v
          ON v.id = d.vehicule_id
        WHERE d.vehicule_id = @vehiculeId
          AND v.utilisateur_id = @utilisateurId
        ORDER BY d.date DESC
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
        'utilisateurId': utilisateurId,
      },
    );

    return resultat
        .map(_convertirLigneEnDepense)
        .toList();
  }

  @override
  Future<Depense?> obtenirParId({
    required String utilisateurId,
    required String depenseId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          d.id,
          d.vehicule_id,
          d.categorie_id,
          d.date,
          d.montant,
          d.description
        FROM depenses d
        INNER JOIN vehicules v
          ON v.id = d.vehicule_id
        WHERE d.id = @depenseId
          AND v.utilisateur_id = @utilisateurId
        ''',
      ),
      parameters: {
        'depenseId': depenseId,
        'utilisateurId': utilisateurId,
      },
    );

    if (resultat.isEmpty) {
      return null;
    }

    return _convertirLigneEnDepense(resultat.first);
  }

  @override
  Future<Depense> creer({
    required String utilisateurId,
    required Depense depense,
  }) async {
    await _verifierVehiculeAutorise(
      utilisateurId: utilisateurId,
      vehiculeId: depense.vehiculeId,
    );

    await _verifierCategorieAutorisee(
      utilisateurId: utilisateurId,
      categorieId: depense.categorieId,
    );

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        INSERT INTO depenses (
          id,
          vehicule_id,
          categorie_id,
          date,
          montant,
          description
        )
        VALUES (
          @id,
          @vehiculeId,
          @categorieId,
          @date,
          @montant,
          @description
        )
        ''',
      ),
      parameters: {
        'id': depense.id,
        'vehiculeId': depense.vehiculeId,
        'categorieId': depense.categorieId,
        'date': depense.date,
        'montant': depense.montant,
        'description': depense.description,
      },
    );

    return depense;
  }

  @override
  Future<Depense> modifier({
    required String utilisateurId,
    required Depense depense,
  }) async {
    final depenseExistante = await obtenirParId(
      utilisateurId: utilisateurId,
      depenseId: depense.id,
    );

    if (depenseExistante == null) {
      throw StateError('Dépense introuvable.');
    }

    await _verifierVehiculeAutorise(
      utilisateurId: utilisateurId,
      vehiculeId: depense.vehiculeId,
    );

    await _verifierCategorieAutorisee(
      utilisateurId: utilisateurId,
      categorieId: depense.categorieId,
    );

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        UPDATE depenses
        SET
          vehicule_id = @vehiculeId,
          categorie_id = @categorieId,
          date = @date,
          montant = @montant,
          description = @description
        WHERE id = @id
        ''',
      ),
      parameters: {
        'id': depense.id,
        'vehiculeId': depense.vehiculeId,
        'categorieId': depense.categorieId,
        'date': depense.date,
        'montant': depense.montant,
        'description': depense.description,
      },
    );

    return depense;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String depenseId,
  }) async {
    final depenseExistante = await obtenirParId(
      utilisateurId: utilisateurId,
      depenseId: depenseId,
    );

    if (depenseExistante == null) {
      throw StateError('Dépense introuvable.');
    }

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM depenses
        WHERE id = @depenseId
        ''',
      ),
      parameters: {
        'depenseId': depenseId,
      },
    );
  }

  Future<void> _verifierVehiculeAutorise({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT id
        FROM vehicules
        WHERE id = @vehiculeId
          AND utilisateur_id = @utilisateurId
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
        'utilisateurId': utilisateurId,
      },
    );

    if (resultat.isEmpty) {
      throw StateError(
        'Véhicule introuvable ou non autorisé.',
      );
    }
  }

  Future<void> _verifierCategorieAutorisee({
    required String utilisateurId,
    required String categorieId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT id
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
      throw StateError(
        'Catégorie de dépense introuvable ou non autorisée.',
      );
    }
  }

  Depense _convertirLigneEnDepense(
    ResultRow ligne,
  ) {
    final montant = ligne[4];

    return Depense(
      id: ligne[0] as String,
      vehiculeId: ligne[1] as String,
      categorieId: ligne[2] as String,
      date: ligne[3] as DateTime,
      montant: montant is num
          ? montant.toDouble()
          : double.parse(montant as String),
      description: ligne[5] as String?,
    );
  }
}