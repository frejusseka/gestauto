import 'package:postgres/postgres.dart';

import '../../coeur/base_de_donnees/connexion_postgresql.dart';
import '../../domaine/depots/depot_vehicule.dart';
import '../../domaine/entites/vehicule.dart';

class DepotVehiculePostgresql implements DepotVehicule {
  final ConnexionPostgresql _connexionPostgresql;

  DepotVehiculePostgresql({
    required ConnexionPostgresql connexionPostgresql,
  }) : _connexionPostgresql = connexionPostgresql;

  @override
  Future<List<Vehicule>> obtenirTous(String utilisateurId) async {
    final resultat = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          id,
          utilisateur_id,
          type,
          marque,
          modele,
          immatriculation,
          annee,
          kilometrage,
          date_acquisition,
          prix_acquisition,
          statut,
          montant_versement_attendu,
          photo
        FROM vehicules
        WHERE utilisateur_id = @utilisateurId
        ORDER BY marque, modele
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
      },
    );

    return resultat.map(_convertirLigneEnVehicule).toList();
  }

  @override
  Future<Vehicule?> obtenirParId({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    final resultat = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          id,
          utilisateur_id,
          type,
          marque,
          modele,
          immatriculation,
          annee,
          kilometrage,
          date_acquisition,
          prix_acquisition,
          statut,
          montant_versement_attendu,
          photo
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

    return _convertirLigneEnVehicule(resultat.first);
  }

  @override
  Future<Vehicule> creer(Vehicule vehicule) async {
    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        INSERT INTO vehicules (
          id,
          utilisateur_id,
          type,
          marque,
          modele,
          immatriculation,
          annee,
          kilometrage,
          date_acquisition,
          prix_acquisition,
          statut,
          montant_versement_attendu,
          photo
        )
        VALUES (
          @id,
          @utilisateurId,
          @type,
          @marque,
          @modele,
          @immatriculation,
          @annee,
          @kilometrage,
          @dateAcquisition,
          @prixAcquisition,
          @statut,
          @montantVersementAttendu,
          @photo
        )
        ''',
      ),
      parameters: {
        'id': vehicule.id,
        'utilisateurId': vehicule.utilisateurId,
        'type': _convertirTypeVersBase(vehicule.type),
        'marque': vehicule.marque,
        'modele': vehicule.modele,
        'immatriculation': vehicule.immatriculation,
        'annee': vehicule.annee,
        'kilometrage': vehicule.kilometrage,
        'dateAcquisition': vehicule.dateAcquisition,
        'prixAcquisition': vehicule.prixAcquisition,
        'statut': _convertirStatutVersBase(vehicule.statut),
        'montantVersementAttendu':
            vehicule.montantVersementAttendu,
        'photo': vehicule.photo,
      },
    );

    return vehicule;
  }

  @override
  Future<Vehicule> modifier(Vehicule vehicule) async {
    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        UPDATE vehicules
        SET
          type = @type,
          marque = @marque,
          modele = @modele,
          immatriculation = @immatriculation,
          annee = @annee,
          kilometrage = @kilometrage,
          date_acquisition = @dateAcquisition,
          prix_acquisition = @prixAcquisition,
          statut = @statut,
          montant_versement_attendu = @montantVersementAttendu,
          photo = @photo
        WHERE id = @id
          AND utilisateur_id = @utilisateurId
        ''',
      ),
      parameters: {
        'id': vehicule.id,
        'utilisateurId': vehicule.utilisateurId,
        'type': _convertirTypeVersBase(vehicule.type),
        'marque': vehicule.marque,
        'modele': vehicule.modele,
        'immatriculation': vehicule.immatriculation,
        'annee': vehicule.annee,
        'kilometrage': vehicule.kilometrage,
        'dateAcquisition': vehicule.dateAcquisition,
        'prixAcquisition': vehicule.prixAcquisition,
        'statut': _convertirStatutVersBase(vehicule.statut),
        'montantVersementAttendu':
            vehicule.montantVersementAttendu,
        'photo': vehicule.photo,
      },
    );

    return vehicule;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM vehicules
        WHERE id = @vehiculeId
          AND utilisateur_id = @utilisateurId
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
        'utilisateurId': utilisateurId,
      },
    );
  }

  Vehicule _convertirLigneEnVehicule(ResultRow ligne) {
    return Vehicule(
      id: ligne[0] as String,
      utilisateurId: ligne[1] as String,
      type: _convertirTypeDepuisBase(ligne[2] as String),
      marque: ligne[3] as String,
      modele: ligne[4] as String,
      immatriculation: ligne[5] as String,
      annee: ligne[6] as int,
      kilometrage: ligne[7] as int,
      dateAcquisition: ligne[8] as DateTime,
      prixAcquisition: double.parse(ligne[9].toString()),
      statut: _convertirStatutDepuisBase(ligne[10] as String),
      montantVersementAttendu:
          double.parse(ligne[11].toString()),
      photo: ligne[12] as String?,
    );
  }

  String _convertirTypeVersBase(TypeVehicule type) {
    switch (type) {
      case TypeVehicule.voiture:
        return 'voiture';
      case TypeVehicule.moto:
        return 'moto';
    }
  }

  TypeVehicule _convertirTypeDepuisBase(String type) {
    switch (type) {
      case 'voiture':
        return TypeVehicule.voiture;
      case 'moto':
        return TypeVehicule.moto;
      default:
        throw StateError(
          'Type de véhicule inconnu : $type',
        );
    }
  }

  String _convertirStatutVersBase(StatutVehicule statut) {
    switch (statut) {
      case StatutVehicule.enService:
        return 'enService';
      case StatutVehicule.disponible:
        return 'disponible';
      case StatutVehicule.enMaintenance:
        return 'enMaintenance';
      case StatutVehicule.enPanne:
        return 'enPanne';
      case StatutVehicule.horsService:
        return 'horsService';
    }
  }

  StatutVehicule _convertirStatutDepuisBase(String statut) {
    switch (statut) {
      case 'enService':
        return StatutVehicule.enService;
      case 'disponible':
        return StatutVehicule.disponible;
      case 'enMaintenance':
        return StatutVehicule.enMaintenance;
      case 'enPanne':
        return StatutVehicule.enPanne;
      case 'horsService':
        return StatutVehicule.horsService;
      default:
        throw StateError(
          'Statut de véhicule inconnu : $statut',
        );
    }
  }
}