import 'package:postgres/postgres.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:gestauto_backend/coeur/base_de_donnees/connexion_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_panne_postgresql.dart';
import 'package:gestauto_backend/domaine/entites/panne.dart';

void main() {
  late ConnexionPostgresql connexionPostgresql;
  late DepotPannePostgresql depotPanne;

  late String utilisateurId;
  late String utilisateurIdSecond;
  late String vehiculeId;
  late String vehiculeIdSecond;
  late String panneId;

  const uuid = Uuid();

  setUpAll(() async {
    connexionPostgresql = ConnexionPostgresql();
    await connexionPostgresql.ouvrir();

    depotPanne = DepotPannePostgresql(
      connexionPostgresql: connexionPostgresql,
    );

    utilisateurId = uuid.v4();
    utilisateurIdSecond = uuid.v4();
    vehiculeId = uuid.v4();
    vehiculeIdSecond = uuid.v4();

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
        'nom': 'Utilisateur Test Panne',
        'email': 'test-panne-$utilisateurId@gestauto.com',
        'motDePasse': 'mot-de-passe-test',
      },
    );

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
        'id': utilisateurIdSecond,
        'nom': 'Autre Utilisateur Test Panne',
        'email': 'autre-panne-$utilisateurIdSecond@gestauto.com',
        'motDePasse': 'mot-de-passe-test',
      },
    );

    await connexionPostgresql.connexion.execute(
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
          montant_versement_attendu
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
          @montantVersementAttendu
        )
        ''',
      ),
      parameters: {
        'id': vehiculeId,
        'utilisateurId': utilisateurId,
        'type': 'voiture',
        'marque': 'Toyota',
        'modele': 'Corolla',
        'immatriculation': 'TEST-PANNE-001',
        'annee': 2024,
        'kilometrage': 15000,
        'dateAcquisition': DateTime(2024, 1, 15),
        'prixAcquisition': 15000000,
        'statut': 'disponible',
        'montantVersementAttendu': 20000,
      },
    );

    await connexionPostgresql.connexion.execute(
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
          montant_versement_attendu
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
          @montantVersementAttendu
        )
        ''',
      ),
      parameters: {
        'id': vehiculeIdSecond,
        'utilisateurId': utilisateurIdSecond,
        'type': 'moto',
        'marque': 'Yamaha',
        'modele': 'XMAX',
        'immatriculation': 'TEST-PANNE-002',
        'annee': 2023,
        'kilometrage': 12000,
        'dateAcquisition': DateTime(2023, 5, 10),
        'prixAcquisition': 5000000,
        'statut': 'disponible',
        'montantVersementAttendu': 10000,
      },
    );
  });

  tearDownAll(() async {
    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM pannes
        WHERE vehicule_id IN (
          @vehiculeId,
          @vehiculeIdSecond
        )
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
        'vehiculeIdSecond': vehiculeIdSecond,
      },
    );

    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM vehicules
        WHERE id IN (
          @vehiculeId,
          @vehiculeIdSecond
        )
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
        'vehiculeIdSecond': vehiculeIdSecond,
      },
    );

    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM utilisateurs
        WHERE id IN (
          @utilisateurId,
          @utilisateurIdSecond
        )
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
        'utilisateurIdSecond': utilisateurIdSecond,
      },
    );

    await connexionPostgresql.fermer();
  });

  test(
    'créer une panne pour un véhicule autorisé',
    () async {
      final panne = Panne(
        id: uuid.v4(),
        vehiculeId: vehiculeId,
        date: DateTime(2026, 9, 29),
        description: 'Problème de frein',
        gravite: GravitePanne.grave,
        resolue: false,
      );

      panneId = panne.id;

      final resultat = await depotPanne.creer(
        utilisateurId: utilisateurId,
        panne: panne,
      );

      expect(resultat.id, panne.id);
      expect(resultat.vehiculeId, vehiculeId);
      expect(
        resultat.gravite,
        GravitePanne.grave,
      );
      expect(resultat.resolue, isFalse);
      expect(resultat.dateResolution, isNull);
    },
  );

  test(
    'récupérer toutes les pannes d un utilisateur',
    () async {
      final pannes = await depotPanne.obtenirTous(
        utilisateurId: utilisateurId,
      );

      expect(pannes, isNotEmpty);
      expect(
        pannes.any(
          (panne) => panne.id == panneId,
        ),
        isTrue,
      );
    },
  );

  test(
    'récupérer les pannes d un véhicule',
    () async {
      final pannes =
          await depotPanne.obtenirParVehicule(
        utilisateurId: utilisateurId,
        vehiculeId: vehiculeId,
      );

      expect(pannes, isNotEmpty);
      expect(
        pannes.every(
          (panne) => panne.vehiculeId == vehiculeId,
        ),
        isTrue,
      );
    },
  );

  test(
    'récupérer une panne par son identifiant',
    () async {
      final panne = await depotPanne.obtenirParId(
        utilisateurId: utilisateurId,
        panneId: panneId,
      );

      expect(panne, isNotNull);
      expect(panne!.id, panneId);
      expect(
        panne.description,
        'Problème de frein',
      );
    },
  );

  test(
    'modifier une panne',
    () async {
      final panneModifiee = Panne(
        id: panneId,
        vehiculeId: vehiculeId,
        date: DateTime(2026, 9, 29),
        description: 'Frein avant défectueux',
        gravite: GravitePanne.moyenne,
        resolue: true,
        dateResolution: DateTime(2026, 9, 30),
      );

      final resultat = await depotPanne.modifier(
        utilisateurId: utilisateurId,
        panne: panneModifiee,
      );

      expect(
        resultat.description,
        'Frein avant défectueux',
      );
      expect(
        resultat.gravite,
        GravitePanne.moyenne,
      );
      expect(resultat.resolue, isTrue);
      expect(
        resultat.dateResolution,
        DateTime(2026, 9, 30),
      );
    },
  );

  test(
    'refuser la création pour le véhicule d un autre utilisateur',
    () async {
      final panne = Panne(
        id: uuid.v4(),
        vehiculeId: vehiculeIdSecond,
        date: DateTime(2026, 9, 29),
        description: 'Panne non autorisée',
        gravite: GravitePanne.faible,
        resolue: false,
      );

      expect(
        () => depotPanne.creer(
          utilisateurId: utilisateurId,
          panne: panne,
        ),
        throwsA(isA<StateError>()),
      );
    },
  );

  test(
    'refuser la modification avec un véhicule non autorisé',
    () async {
      final panne = Panne(
        id: panneId,
        vehiculeId: vehiculeIdSecond,
        date: DateTime(2026, 9, 29),
        description: 'Tentative non autorisée',
        gravite: GravitePanne.grave,
        resolue: false,
      );

      expect(
        () => depotPanne.modifier(
          utilisateurId: utilisateurId,
          panne: panne,
        ),
        throwsA(isA<StateError>()),
      );
    },
  );

  test(
    'supprimer une panne',
    () async {
      final panneASupprimer = Panne(
        id: uuid.v4(),
        vehiculeId: vehiculeId,
        date: DateTime(2026, 9, 28),
        description: 'Panne temporaire',
        gravite: GravitePanne.faible,
        resolue: true,
        dateResolution: DateTime(2026, 9, 29),
      );

      await depotPanne.creer(
        utilisateurId: utilisateurId,
        panne: panneASupprimer,
      );

      await depotPanne.supprimer(
        utilisateurId: utilisateurId,
        panneId: panneASupprimer.id,
      );

      final resultat = await depotPanne.obtenirParId(
        utilisateurId: utilisateurId,
        panneId: panneASupprimer.id,
      );

      expect(resultat, isNull);
    },
  );
}
