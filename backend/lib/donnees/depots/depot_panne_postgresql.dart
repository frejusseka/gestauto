import 'package:postgres/postgres.dart';

import '../../coeur/base_de_donnees/connexion_postgresql.dart';
import '../../domaine/depots/depot_panne.dart';
import '../../domaine/entites/panne.dart';

class DepotPannePostgresql implements DepotPanne {
  final ConnexionPostgresql _connexionPostgresql;

  DepotPannePostgresql({
    required ConnexionPostgresql connexionPostgresql,
  }) : _connexionPostgresql = connexionPostgresql;

  @override
  Future<List<Panne>> obtenirTous({
    required String utilisateurId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          p.id,
          p.vehicule_id,
          p.date,
          p.description,
          p.gravite,
          p.resolue,
          p.date_resolution
        FROM pannes p
        INNER JOIN vehicules v
          ON v.id = p.vehicule_id
        WHERE v.utilisateur_id = @utilisateurId
        ORDER BY p.date DESC
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
      },
    );

    return resultat
        .map(_convertirLigneEnPanne)
        .toList();
  }

  @override
  Future<List<Panne>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          p.id,
          p.vehicule_id,
          p.date,
          p.description,
          p.gravite,
          p.resolue,
          p.date_resolution
        FROM pannes p
        INNER JOIN vehicules v
          ON v.id = p.vehicule_id
        WHERE p.vehicule_id = @vehiculeId
          AND v.utilisateur_id = @utilisateurId
        ORDER BY p.date DESC
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
        'utilisateurId': utilisateurId,
      },
    );

    return resultat
        .map(_convertirLigneEnPanne)
        .toList();
  }

  @override
  Future<Panne?> obtenirParId({
    required String utilisateurId,
    required String panneId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          p.id,
          p.vehicule_id,
          p.date,
          p.description,
          p.gravite,
          p.resolue,
          p.date_resolution
        FROM pannes p
        INNER JOIN vehicules v
          ON v.id = p.vehicule_id
        WHERE p.id = @panneId
          AND v.utilisateur_id = @utilisateurId
        ''',
      ),
      parameters: {
        'panneId': panneId,
        'utilisateurId': utilisateurId,
      },
    );

    if (resultat.isEmpty) {
      return null;
    }

    return _convertirLigneEnPanne(resultat.first);
  }

  @override
  Future<Panne> creer({
    required String utilisateurId,
    required Panne panne,
  }) async {
    await _verifierVehiculeAutorise(
      utilisateurId: utilisateurId,
      vehiculeId: panne.vehiculeId,
    );

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        INSERT INTO pannes (
          id,
          vehicule_id,
          date,
          description,
          gravite,
          resolue,
          date_resolution
        )
        VALUES (
          @id,
          @vehiculeId,
          @date,
          @description,
          @gravite,
          @resolue,
          @dateResolution
        )
        ''',
      ),
      parameters: {
        'id': panne.id,
        'vehiculeId': panne.vehiculeId,
        'date': panne.date,
        'description': panne.description,
        'gravite': panne.gravite.name,
        'resolue': panne.resolue,
        'dateResolution': panne.dateResolution,
      },
    );

    return panne;
  }

  @override
  Future<Panne> modifier({
    required String utilisateurId,
    required Panne panne,
  }) async {
    final panneExistante = await obtenirParId(
      utilisateurId: utilisateurId,
      panneId: panne.id,
    );

    if (panneExistante == null) {
      throw StateError('Panne introuvable.');
    }

    await _verifierVehiculeAutorise(
      utilisateurId: utilisateurId,
      vehiculeId: panne.vehiculeId,
    );

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        UPDATE pannes
        SET
          vehicule_id = @vehiculeId,
          date = @date,
          description = @description,
          gravite = @gravite,
          resolue = @resolue,
          date_resolution = @dateResolution
        WHERE id = @id
        ''',
      ),
      parameters: {
        'id': panne.id,
        'vehiculeId': panne.vehiculeId,
        'date': panne.date,
        'description': panne.description,
        'gravite': panne.gravite.name,
        'resolue': panne.resolue,
        'dateResolution': panne.dateResolution,
      },
    );

    return panne;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String panneId,
  }) async {
    final panneExistante = await obtenirParId(
      utilisateurId: utilisateurId,
      panneId: panneId,
    );

    if (panneExistante == null) {
      throw StateError('Panne introuvable.');
    }

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM pannes
        WHERE id = @panneId
        ''',
      ),
      parameters: {
        'panneId': panneId,
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

  Panne _convertirLigneEnPanne(
    ResultRow ligne,
  ) {
    return Panne(
      id: ligne[0] as String,
      vehiculeId: ligne[1] as String,
      date: ligne[2] as DateTime,
      description: ligne[3] as String,
      gravite: GravitePanne.values.byName(
        ligne[4] as String,
      ),
      resolue: ligne[5] as bool,
      dateResolution: ligne[6] as DateTime?,
    );
  }
}