import 'package:postgres/postgres.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../lib/coeur/base_de_donnees/connexion_postgresql.dart';
import '../../../lib/donnees/depots/depot_utilisateur_postgresql.dart';
import '../../../lib/donnees/depots/depot_vehicule_postgresql.dart';
import '../../../lib/donnees/depots/depot_versement_postgresql.dart';
import '../../../lib/domaine/entites/utilisateur.dart';
import '../../../lib/domaine/entites/vehicule.dart';
import '../../../lib/domaine/entites/versement.dart';

void main() {
  late ConnexionPostgresql connexionPostgresql;
  late DepotUtilisateurPostgresql depotUtilisateur;
  late DepotVehiculePostgresql depotVehicule;
  late DepotVersementPostgresql depotVersement;

  final uuid = Uuid();

  late String utilisateurId;
  late String vehiculeId;
  late String versementId;

  setUp(() async {
    connexionPostgresql = ConnexionPostgresql();

    await connexionPostgresql.ouvrir();

    depotUtilisateur = DepotUtilisateurPostgresql(
      connexionPostgresql: connexionPostgresql,
    );

    depotVehicule = DepotVehiculePostgresql(
      connexionPostgresql: connexionPostgresql,
    );

    depotVersement = DepotVersementPostgresql(
      connexionPostgresql: connexionPostgresql,
    );

    utilisateurId = uuid.v4();
    vehiculeId = uuid.v4();
    versementId = uuid.v4();

    await depotUtilisateur.creer(
      Utilisateur(
        id: utilisateurId,
        nom: 'Utilisateur Test Versement',
        email:
            'test-versement-$utilisateurId@test.com',
        motDePasse: 'mot-de-passe-test',
      ),
    );

    await depotVehicule.creer(
      Vehicule(
        id: vehiculeId,
        utilisateurId: utilisateurId,
        type: TypeVehicule.moto,
        marque: 'Yamaha',
        modele: 'MT-15',
        immatriculation:
            'TEST-${vehiculeId.substring(0, 8)}',
        annee: 2025,
        kilometrage: 5000,
        dateAcquisition: DateTime(2025, 1, 15),
        prixAcquisition: 3500000,
        statut: StatutVehicule.enService,
        montantVersementAttendu: 15000,
      ),
    );
  });

  tearDown(() async {
    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM versements
        WHERE id = @id
        ''',
      ),
      parameters: {
        'id': versementId,
      },
    );

    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM vehicules
        WHERE id = @id
        ''',
      ),
      parameters: {
        'id': vehiculeId,
      },
    );

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
    'crée, récupère, modifie et supprime un versement',
    () async {
      final versement = Versement(
        id: versementId,
        vehiculeId: vehiculeId,
        date: DateTime(2026, 9, 29),
        montantAttendu: 15000,
        montantVerse: 12000,
      );

      final versementCree =
          await depotVersement.creer(
        utilisateurId: utilisateurId,
        versement: versement,
      );

      expect(versementCree.id, versementId);
      expect(versementCree.vehiculeId, vehiculeId);
      expect(versementCree.ecart, 3000);
      expect(
        versementCree.statut,
        StatutVersement.infraction,
      );

      final versementRecupere =
          await depotVersement.obtenirParId(
        utilisateurId: utilisateurId,
        versementId: versementId,
      );

      expect(versementRecupere, isNotNull);
      expect(
        versementRecupere!.montantVerse,
        12000,
      );

      final versementsVehicule =
          await depotVersement.obtenirParVehicule(
        utilisateurId: utilisateurId,
        vehiculeId: vehiculeId,
      );

      expect(versementsVehicule, hasLength(1));
      expect(
        versementsVehicule.first.id,
        versementId,
      );

      final versementModifie = Versement(
        id: versementId,
        vehiculeId: vehiculeId,
        date: DateTime(2026, 9, 29),
        montantAttendu: 15000,
        montantVerse: 15000,
      );

      final resultatModification =
          await depotVersement.modifier(
        utilisateurId: utilisateurId,
        versement: versementModifie,
      );

      expect(
        resultatModification.ecart,
        0,
      );

      expect(
        resultatModification.statut,
        StatutVersement.conforme,
      );

      await depotVersement.supprimer(
        utilisateurId: utilisateurId,
        versementId: versementId,
      );

      final versementApresSuppression =
          await depotVersement.obtenirParId(
        utilisateurId: utilisateurId,
        versementId: versementId,
      );

      expect(
        versementApresSuppression,
        isNull,
      );
    },
  );
}