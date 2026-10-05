import 'package:postgres/postgres.dart';

import '../../coeur/base_de_donnees/connexion_postgresql.dart';
import '../../domaine/depots/depot_versement.dart';
import '../../domaine/entites/versement.dart';

class DepotVersementPostgresql implements DepotVersement {
  final ConnexionPostgresql _connexionPostgresql;

  DepotVersementPostgresql({
    required ConnexionPostgresql connexionPostgresql,
  }) : _connexionPostgresql = connexionPostgresql;

  @override
  Future<List<Versement>> obtenirTous({
    required String utilisateurId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          v.id,
          v.vehicule_id,
          v.date,
          v.montant_attendu,
          v.montant_verse
        FROM versements v
        INNER JOIN vehicules ve
          ON ve.id = v.vehicule_id
        WHERE ve.utilisateur_id = @utilisateurId
        ORDER BY v.date DESC
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
      },
    );

    return resultat.map(_convertirLigneEnVersement).toList();
  }

  @override
  Future<List<Versement>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          v.id,
          v.vehicule_id,
          v.date,
          v.montant_attendu,
          v.montant_verse
        FROM versements v
        INNER JOIN vehicules ve
          ON ve.id = v.vehicule_id
        WHERE ve.utilisateur_id = @utilisateurId
          AND v.vehicule_id = @vehiculeId
        ORDER BY v.date DESC
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
        'vehiculeId': vehiculeId,
      },
    );

    return resultat.map(_convertirLigneEnVersement).toList();
  }

  @override
  Future<Versement?> obtenirParId({
    required String utilisateurId,
    required String versementId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          v.id,
          v.vehicule_id,
          v.date,
          v.montant_attendu,
          v.montant_verse
        FROM versements v
        INNER JOIN vehicules ve
          ON ve.id = v.vehicule_id
        WHERE v.id = @versementId
          AND ve.utilisateur_id = @utilisateurId
        ''',
      ),
      parameters: {
        'versementId': versementId,
        'utilisateurId': utilisateurId,
      },
    );

    if (resultat.isEmpty) {
      return null;
    }

    return _convertirLigneEnVersement(resultat.first);
  }

  @override
  Future<Versement> creer({
    required String utilisateurId,
    required Versement versement,
  }) async {
    final vehicule = await _obtenirVehiculeAutorise(
      utilisateurId: utilisateurId,
      vehiculeId: versement.vehiculeId,
    );

    if (vehicule == null) {
      throw StateError(
        'Le véhicule du versement est introuvable '
        'ou n appartient pas à l utilisateur.',
      );
    }

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        INSERT INTO versements (
          id,
          vehicule_id,
          date,
          montant_attendu,
          montant_verse
        )
        VALUES (
          @id,
          @vehiculeId,
          @date,
          @montantAttendu,
          @montantVerse
        )
        ''',
      ),
      parameters: {
        'id': versement.id,
        'vehiculeId': versement.vehiculeId,
        'date': versement.date,
        'montantAttendu': versement.montantAttendu,
        'montantVerse': versement.montantVerse,
      },
    );

    return versement;
  }

  @override
  Future<Versement> modifier({
    required String utilisateurId,
    required Versement versement,
  }) async {
    final versementExistant = await obtenirParId(
      utilisateurId: utilisateurId,
      versementId: versement.id,
    );

    if (versementExistant == null) {
      throw StateError(
        'Le versement est introuvable '
        'ou n appartient pas à l utilisateur.',
      );
    }

    final vehicule = await _obtenirVehiculeAutorise(
      utilisateurId: utilisateurId,
      vehiculeId: versement.vehiculeId,
    );

    if (vehicule == null) {
      throw StateError(
        'Le véhicule du versement est introuvable '
        'ou n appartient pas à l utilisateur.',
      );
    }

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        UPDATE versements
        SET
          vehicule_id = @vehiculeId,
          date = @date,
          montant_attendu = @montantAttendu,
          montant_verse = @montantVerse
        WHERE id = @id
        ''',
      ),
      parameters: {
        'id': versement.id,
        'vehiculeId': versement.vehiculeId,
        'date': versement.date,
        'montantAttendu': versement.montantAttendu,
        'montantVerse': versement.montantVerse,
      },
    );

    return versement;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String versementId,
  }) async {
    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM versements
        WHERE id = @versementId
          AND vehicule_id IN (
            SELECT id
            FROM vehicules
            WHERE utilisateur_id = @utilisateurId
          )
        ''',
      ),
      parameters: {
        'versementId': versementId,
        'utilisateurId': utilisateurId,
      },
    );
  }

  Future<String?> _obtenirVehiculeAutorise({
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
      return null;
    }

    return resultat.first[0] as String;
  }

  Versement _convertirLigneEnVersement(
    ResultRow ligne,
  ) {
    return Versement(
      id: ligne[0] as String,
      vehiculeId: ligne[1] as String,
      date: ligne[2] as DateTime,
      montantAttendu:
          double.parse(ligne[3].toString()),
      montantVerse:
          double.parse(ligne[4].toString()),
    );
  }
}