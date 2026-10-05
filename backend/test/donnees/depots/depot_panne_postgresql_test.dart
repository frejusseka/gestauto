import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../lib/coeur/base_de_donnees/connexion_postgresql.dart';
import '../../../lib/donnees/depots/depot_panne_postgresql.dart';
import '../../../lib/domaine/entites/panne.dart';

void main() {
  late ConnexionPostgresql connexionPostgresql;
  late DepotPannePostgresql depotPanne;

  const utilisateurId =
      '11111111-1111-1111-1111-111111111111';

  const utilisateurIdSecond =
      '248e6915-ac22-4e36-8139-da3c94b27f5a';

  late String vehiculeId;
  late String vehiculeIdSecond;
  late String panneId;

  setUpAll(() async {
    connexionPostgresql = ConnexionPostgresql();
    await connexionPostgresql.ouvrir();

    depotPanne = DepotPannePostgresql(
      connexionPostgresql: connexionPostgresql,
    );

    vehiculeId = const Uuid().v4();
    vehiculeIdSecond = const Uuid().v4();

    await connexionPostgresql.connexion.execute(
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
        '$vehiculeId',
        '$utilisateurId',
        'voiture',
        'Toyota',
        'Corolla',
        'TEST-PANNE-001',
        2024,
        15000,
        '2024-01-15',
        15000000,
        'disponible',
        20000
      )
      ''',
    );

    await connexionPostgresql.connexion.execute(
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
        '$vehiculeIdSecond',
        '$utilisateurIdSecond',
        'moto',
        'Yamaha',
        'XMAX',
        'TEST-PANNE-002',
        2023,
        12000,
        '2023-05-10',
        5000000,
        'disponible',
        10000
      )
      ''',
    );
  });

  tearDownAll(() async {
    await connexionPostgresql.connexion.execute(
      '''
      DELETE FROM pannes
      WHERE id = '$panneId'
      ''',
    );

    await connexionPostgresql.connexion.execute(
      '''
      DELETE FROM vehicules
      WHERE id IN (
        '$vehiculeId',
        '$vehiculeIdSecond'
      )
      ''',
    );

    await connexionPostgresql.fermer();
  });

  test(
    'créer une panne pour un véhicule autorisé',
    () async {
      final panne = Panne(
        id: const Uuid().v4(),
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
        id: const Uuid().v4(),
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
        id: const Uuid().v4(),
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