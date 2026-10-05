import 'package:postgres/postgres.dart';

import '../../coeur/base_de_donnees/connexion_postgresql.dart';
import '../../domaine/depots/depot_entretien.dart';
import '../../domaine/entites/entretien.dart';

class DepotEntretienPostgresql implements DepotEntretien {
  final ConnexionPostgresql _connexionPostgresql;

  DepotEntretienPostgresql({
    required ConnexionPostgresql connexionPostgresql,
  }) : _connexionPostgresql = connexionPostgresql;

  @override
  Future<List<Entretien>> obtenirTous({
    required String utilisateurId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          e.id,
          e.vehicule_id,
          e.type,
          e.date,
          e.kilometrage,
          e.montant,
          e.prochain_kilometrage,
          e.prochaine_date,
          e.notes
        FROM entretiens e
        INNER JOIN vehicules v
          ON v.id = e.vehicule_id
        WHERE v.utilisateur_id = @utilisateurId
        ORDER BY e.date DESC
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
      },
    );

    return resultat
        .map(_convertirLigneEnEntretien)
        .toList();
  }

  @override
  Future<List<Entretien>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          e.id,
          e.vehicule_id,
          e.type,
          e.date,
          e.kilometrage,
          e.montant,
          e.prochain_kilometrage,
          e.prochaine_date,
          e.notes
        FROM entretiens e
        INNER JOIN vehicules v
          ON v.id = e.vehicule_id
        WHERE e.vehicule_id = @vehiculeId
          AND v.utilisateur_id = @utilisateurId
        ORDER BY e.date DESC
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
        'utilisateurId': utilisateurId,
      },
    );

    return resultat
        .map(_convertirLigneEnEntretien)
        .toList();
  }

  @override
  Future<Entretien?> obtenirParId({
    required String utilisateurId,
    required String entretienId,
  }) async {
    final resultat =
        await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          e.id,
          e.vehicule_id,
          e.type,
          e.date,
          e.kilometrage,
          e.montant,
          e.prochain_kilometrage,
          e.prochaine_date,
          e.notes
        FROM entretiens e
        INNER JOIN vehicules v
          ON v.id = e.vehicule_id
        WHERE e.id = @entretienId
          AND v.utilisateur_id = @utilisateurId
        ''',
      ),
      parameters: {
        'entretienId': entretienId,
        'utilisateurId': utilisateurId,
      },
    );

    if (resultat.isEmpty) {
      return null;
    }

    return _convertirLigneEnEntretien(resultat.first);
  }

  @override
  Future<Entretien> creer({
    required String utilisateurId,
    required Entretien entretien,
  }) async {
    await _verifierVehiculeAutorise(
      utilisateurId: utilisateurId,
      vehiculeId: entretien.vehiculeId,
    );

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        INSERT INTO entretiens (
          id,
          vehicule_id,
          type,
          date,
          kilometrage,
          montant,
          prochain_kilometrage,
          prochaine_date,
          notes
        )
        VALUES (
          @id,
          @vehiculeId,
          @type,
          @date,
          @kilometrage,
          @montant,
          @prochainKilometrage,
          @prochaineDate,
          @notes
        )
        ''',
      ),
      parameters: {
        'id': entretien.id,
        'vehiculeId': entretien.vehiculeId,
        'type': entretien.type,
        'date': entretien.date,
        'kilometrage': entretien.kilometrage,
        'montant': entretien.montant,
        'prochainKilometrage':
            entretien.prochainKilometrage,
        'prochaineDate': entretien.prochaineDate,
        'notes': entretien.notes,
      },
    );

    return entretien;
  }

  @override
  Future<Entretien> modifier({
    required String utilisateurId,
    required Entretien entretien,
  }) async {
    final entretienExistant = await obtenirParId(
      utilisateurId: utilisateurId,
      entretienId: entretien.id,
    );

    if (entretienExistant == null) {
      throw StateError('Entretien introuvable.');
    }

    await _verifierVehiculeAutorise(
      utilisateurId: utilisateurId,
      vehiculeId: entretien.vehiculeId,
    );

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        UPDATE entretiens
        SET
          vehicule_id = @vehiculeId,
          type = @type,
          date = @date,
          kilometrage = @kilometrage,
          montant = @montant,
          prochain_kilometrage = @prochainKilometrage,
          prochaine_date = @prochaineDate,
          notes = @notes
        WHERE id = @id
        ''',
      ),
      parameters: {
        'id': entretien.id,
        'vehiculeId': entretien.vehiculeId,
        'type': entretien.type,
        'date': entretien.date,
        'kilometrage': entretien.kilometrage,
        'montant': entretien.montant,
        'prochainKilometrage':
            entretien.prochainKilometrage,
        'prochaineDate': entretien.prochaineDate,
        'notes': entretien.notes,
      },
    );

    return entretien;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String entretienId,
  }) async {
    final entretienExistant = await obtenirParId(
      utilisateurId: utilisateurId,
      entretienId: entretienId,
    );

    if (entretienExistant == null) {
      throw StateError('Entretien introuvable.');
    }

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM entretiens
        WHERE id = @entretienId
        ''',
      ),
      parameters: {
        'entretienId': entretienId,
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

  Entretien _convertirLigneEnEntretien(
    ResultRow ligne,
  ) {
    final montant = ligne[5];

    return Entretien(
      id: ligne[0] as String,
      vehiculeId: ligne[1] as String,
      type: ligne[2] as String,
      date: ligne[3] as DateTime,
      kilometrage: ligne[4] as int,
      montant: montant is num
          ? montant.toDouble()
          : double.parse(montant as String),
      prochainKilometrage: ligne[6] as int?,
      prochaineDate: ligne[7] as DateTime?,
      notes: ligne[8] as String?,
    );
  }
}