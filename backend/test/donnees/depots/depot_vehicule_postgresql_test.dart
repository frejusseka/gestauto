import 'package:postgres/postgres.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:gestauto_backend/coeur/base_de_donnees/connexion_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_vehicule_postgresql.dart';
import 'package:gestauto_backend/domaine/entites/vehicule.dart';

void main() {
  late ConnexionPostgresql connexionPostgresql;
  late DepotVehiculePostgresql depotVehicule;
  late String utilisateurId;
  late String vehiculeId;

  const uuid = Uuid();

  setUp(() async {
    connexionPostgresql = ConnexionPostgresql();

    await connexionPostgresql.ouvrir();

    depotVehicule = DepotVehiculePostgresql(
      connexionPostgresql: connexionPostgresql,
    );

    utilisateurId = uuid.v4();
    vehiculeId = uuid.v4();

    await connexionPostgresql.connexion.execute(
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
        'id': utilisateurId,
        'nom': 'Utilisateur Test Véhicule',
        'email': 'test-$utilisateurId@gestauto.com',
        'motDePasse': 'mot-de-passe-test',
      },
    );
  });

  tearDown(() async {
    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM utilisateurs
        WHERE id = @id
        ''',
      ),
      parameters: {
        'id': utilisateurId,
      },
    );

    await connexionPostgresql.fermer();
  });

  test(
    'le dépôt doit effectuer le CRUD complet d un véhicule',
    () async {
      final vehicule = Vehicule(
        id: vehiculeId,
        utilisateurId: utilisateurId,
        type: TypeVehicule.voiture,
        marque: 'Toyota',
        modele: 'Corolla',
        immatriculation: 'TEST-${vehiculeId.substring(0, 8)}',
        annee: 2024,
        kilometrage: 15000,
        dateAcquisition: DateTime(2024, 1, 15),
        prixAcquisition: 12500000,
        statut: StatutVehicule.enService,
        montantVersementAttendu: 20000,
        photo: null,
      );

      final vehiculeCree = await depotVehicule.creer(vehicule);

      expect(vehiculeCree.id, vehiculeId);
      expect(vehiculeCree.marque, 'Toyota');
      expect(vehiculeCree.modele, 'Corolla');

      final vehiculeTrouve = await depotVehicule.obtenirParId(
        utilisateurId: utilisateurId,
        vehiculeId: vehiculeId,
      );

      expect(vehiculeTrouve, isNotNull);
      expect(
    vehiculeTrouve!.immatriculation,
  'TEST-${vehiculeId.substring(0, 8)}',
);

      final vehiculeModifie = Vehicule(
        id: vehiculeId,
        utilisateurId: utilisateurId,
        type: TypeVehicule.voiture,
        marque: 'Toyota',
        modele: 'Corolla',
        immatriculation: 'TEST-${vehiculeId.substring(0, 8)}',
        annee: 2024,
        kilometrage: 18000,
        dateAcquisition: DateTime(2024, 1, 15),
        prixAcquisition: 12500000,
        statut: StatutVehicule.enMaintenance,
        montantVersementAttendu: 22000,
        photo: null,
      );

      await depotVehicule.modifier(vehiculeModifie);

      final vehiculeApresModification =
          await depotVehicule.obtenirParId(
        utilisateurId: utilisateurId,
        vehiculeId: vehiculeId,
      );

      expect(vehiculeApresModification, isNotNull);
      expect(
        vehiculeApresModification!.kilometrage,
        18000,
      );
      expect(
        vehiculeApresModification.statut,
        StatutVehicule.enMaintenance,
      );
      expect(
        vehiculeApresModification.montantVersementAttendu,
        22000,
      );

      final vehicules =
          await depotVehicule.obtenirTous(utilisateurId);

      expect(vehicules.length, 1);
      expect(vehicules.first.id, vehiculeId);

      await depotVehicule.supprimer(
        utilisateurId: utilisateurId,
        vehiculeId: vehiculeId,
      );

      final vehiculeApresSuppression =
          await depotVehicule.obtenirParId(
        utilisateurId: utilisateurId,
        vehiculeId: vehiculeId,
      );

      expect(vehiculeApresSuppression, isNull);
    },
  );
}