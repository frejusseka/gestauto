import 'package:postgres/postgres.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../lib/coeur/base_de_donnees/connexion_postgresql.dart';
import '../../../lib/domaine/entites/depense.dart';
import '../../../lib/donnees/depots/depot_depense_postgresql.dart';

void main() {
  late ConnexionPostgresql connexionPostgresql;
  late DepotDepensePostgresql depotDepense;

  late String utilisateurId;
  late String vehiculeId;
  late String categorieId;

  setUp(() async {
    connexionPostgresql = ConnexionPostgresql();
    await connexionPostgresql.ouvrir();

    depotDepense = DepotDepensePostgresql(
      connexionPostgresql: connexionPostgresql,
    );

    utilisateurId = const Uuid().v4();
    vehiculeId = const Uuid().v4();
    categorieId = const Uuid().v4();

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
        'nom': 'Utilisateur Test Dépense',
        'email': 'test-$utilisateurId@example.com',
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
        'id': vehiculeId,
        'utilisateurId': utilisateurId,
        'type': 'moto',
        'marque': 'Yamaha',
        'modele': 'XMAX',
        'immatriculation': 'TEST-$vehiculeId',
        'annee': 2025,
        'kilometrage': 10000,
        'dateAcquisition': DateTime(2025, 1, 1),
        'prixAcquisition': 2500000,
        'statut': 'enService',
        'montantVersementAttendu': 15000,
        'photo': null,
      },
    );

    await connexionPostgresql.connexion.execute(
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
        'id': categorieId,
        'utilisateurId': utilisateurId,
        'nom': 'Réparation Test',
      },
    );
  });

  tearDown(() async {
    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM depenses
        WHERE vehicule_id = @vehiculeId
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
      },
    );

    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM categories_depenses
        WHERE id = @categorieId
        ''',
      ),
      parameters: {
        'categorieId': categorieId,
      },
    );

    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM vehicules
        WHERE id = @vehiculeId
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
      },
    );

    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM utilisateurs
        WHERE id = @utilisateurId
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
      },
    );

    await connexionPostgresql.fermer();
  });

  test(
    'crée une dépense pour un véhicule et une catégorie autorisés',
    () async {
      final depense = Depense(
        id: const Uuid().v4(),
        vehiculeId: vehiculeId,
        categorieId: categorieId,
        date: DateTime(2026, 9, 29),
        montant: 15000,
        description: 'Réparation du frein',
      );

      final depenseCreee = await depotDepense.creer(
        utilisateurId: utilisateurId,
        depense: depense,
      );

      expect(depenseCreee.id, depense.id);
      expect(depenseCreee.vehiculeId, vehiculeId);
      expect(depenseCreee.categorieId, categorieId);
      expect(depenseCreee.montant, 15000);
      expect(
        depenseCreee.description,
        'Réparation du frein',
      );
    },
  );

  test(
    'récupère toutes les dépenses de l utilisateur',
    () async {
      final depense = Depense(
        id: const Uuid().v4(),
        vehiculeId: vehiculeId,
        categorieId: categorieId,
        date: DateTime(2026, 9, 29),
        montant: 12000,
        description: 'Vidange',
      );

      await depotDepense.creer(
        utilisateurId: utilisateurId,
        depense: depense,
      );

      final depenses = await depotDepense.obtenirTous(
        utilisateurId: utilisateurId,
      );

      expect(depenses, hasLength(1));
      expect(depenses.first.id, depense.id);
      expect(depenses.first.montant, 12000);
    },
  );

  test(
    'récupère une dépense par son identifiant',
    () async {
      final depense = Depense(
        id: const Uuid().v4(),
        vehiculeId: vehiculeId,
        categorieId: categorieId,
        date: DateTime(2026, 9, 29),
        montant: 8000,
        description: 'Lavage',
      );

      await depotDepense.creer(
        utilisateurId: utilisateurId,
        depense: depense,
      );

      final depenseTrouvee = await depotDepense.obtenirParId(
        utilisateurId: utilisateurId,
        depenseId: depense.id,
      );

      expect(depenseTrouvee, isNotNull);
      expect(depenseTrouvee!.id, depense.id);
      expect(depenseTrouvee.montant, 8000);
    },
  );

  test(
    'récupère les dépenses d un véhicule',
    () async {
      final depense = Depense(
        id: const Uuid().v4(),
        vehiculeId: vehiculeId,
        categorieId: categorieId,
        date: DateTime(2026, 9, 29),
        montant: 5000,
        description: 'Lavage',
      );

      await depotDepense.creer(
        utilisateurId: utilisateurId,
        depense: depense,
      );

      final depenses =
          await depotDepense.obtenirParVehicule(
        utilisateurId: utilisateurId,
        vehiculeId: vehiculeId,
      );

      expect(depenses, hasLength(1));
      expect(depenses.first.id, depense.id);
    },
  );

  test(
    'modifie une dépense existante',
    () async {
      final depense = Depense(
        id: const Uuid().v4(),
        vehiculeId: vehiculeId,
        categorieId: categorieId,
        date: DateTime(2026, 9, 29),
        montant: 10000,
        description: 'Entretien',
      );

      await depotDepense.creer(
        utilisateurId: utilisateurId,
        depense: depense,
      );

      final depenseModifiee = Depense(
        id: depense.id,
        vehiculeId: vehiculeId,
        categorieId: categorieId,
        date: DateTime(2026, 9, 30),
        montant: 18000,
        description: 'Entretien complet',
      );

      final resultat = await depotDepense.modifier(
        utilisateurId: utilisateurId,
        depense: depenseModifiee,
      );

      expect(resultat.montant, 18000);
      expect(
        resultat.description,
        'Entretien complet',
      );
      expect(
        resultat.date,
        DateTime(2026, 9, 30),
      );
    },
  );

  test(
    'supprime une dépense existante',
    () async {
      final depense = Depense(
        id: const Uuid().v4(),
        vehiculeId: vehiculeId,
        categorieId: categorieId,
        date: DateTime(2026, 9, 29),
        montant: 7000,
        description: 'Nettoyage',
      );

      await depotDepense.creer(
        utilisateurId: utilisateurId,
        depense: depense,
      );

      await depotDepense.supprimer(
        utilisateurId: utilisateurId,
        depenseId: depense.id,
      );

      final depenseTrouvee = await depotDepense.obtenirParId(
        utilisateurId: utilisateurId,
        depenseId: depense.id,
      );

      expect(depenseTrouvee, isNull);
    },
  );

  test(
    'refuse un véhicule appartenant à un autre utilisateur',
    () async {
      final autreUtilisateurId = const Uuid().v4();
      final autreVehiculeId = const Uuid().v4();

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
          'id': autreUtilisateurId,
          'nom': 'Autre Utilisateur',
          'email':
              'autre-$autreUtilisateurId@example.com',
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
          'id': autreVehiculeId,
          'utilisateurId': autreUtilisateurId,
          'type': 'moto',
          'marque': 'Honda',
          'modele': 'PCX',
          'immatriculation': 'AUTRE-$autreVehiculeId',
          'annee': 2025,
          'kilometrage': 5000,
          'dateAcquisition': DateTime(2025, 1, 1),
          'prixAcquisition': 2000000,
          'statut': 'enService',
          'montantVersementAttendu': 15000,
          'photo': null,
        },
      );

      final depense = Depense(
        id: const Uuid().v4(),
        vehiculeId: autreVehiculeId,
        categorieId: categorieId,
        date: DateTime(2026, 9, 29),
        montant: 10000,
        description: 'Tentative non autorisée',
      );

      expect(
        () => depotDepense.creer(
          utilisateurId: utilisateurId,
          depense: depense,
        ),
        throwsA(isA<StateError>()),
      );

      await connexionPostgresql.connexion.execute(
        Sql.named(
          '''
          DELETE FROM vehicules
          WHERE id = @vehiculeId
          ''',
        ),
        parameters: {
          'vehiculeId': autreVehiculeId,
        },
      );

      await connexionPostgresql.connexion.execute(
        Sql.named(
          '''
          DELETE FROM utilisateurs
          WHERE id = @utilisateurId
          ''',
        ),
        parameters: {
          'utilisateurId': autreUtilisateurId,
        },
      );
    },
  );

  test(
    'refuse une catégorie appartenant à un autre utilisateur',
    () async {
      final autreUtilisateurId = const Uuid().v4();
      final autreCategorieId = const Uuid().v4();

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
          'id': autreUtilisateurId,
          'nom': 'Autre Utilisateur Catégorie',
          'email':
              'categorie-$autreUtilisateurId@example.com',
          'motDePasse': 'mot-de-passe-test',
        },
      );

      await connexionPostgresql.connexion.execute(
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
          'id': autreCategorieId,
          'utilisateurId': autreUtilisateurId,
          'nom': 'Catégorie interdite',
        },
      );

      final depense = Depense(
        id: const Uuid().v4(),
        vehiculeId: vehiculeId,
        categorieId: autreCategorieId,
        date: DateTime(2026, 9, 29),
        montant: 10000,
        description: 'Tentative non autorisée',
      );

      expect(
        () => depotDepense.creer(
          utilisateurId: utilisateurId,
          depense: depense,
        ),
        throwsA(isA<StateError>()),
      );

      await connexionPostgresql.connexion.execute(
        Sql.named(
          '''
          DELETE FROM categories_depenses
          WHERE id = @categorieId
          ''',
        ),
        parameters: {
          'categorieId': autreCategorieId,
        },
      );

      await connexionPostgresql.connexion.execute(
        Sql.named(
          '''
          DELETE FROM utilisateurs
          WHERE id = @utilisateurId
          ''',
        ),
        parameters: {
          'utilisateurId': autreUtilisateurId,
        },
      );
    },
  );
}