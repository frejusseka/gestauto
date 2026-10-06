import 'package:postgres/postgres.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:gestauto_backend/coeur/base_de_donnees/connexion_postgresql.dart';
import 'package:gestauto_backend/domaine/entites/entretien.dart';
import 'package:gestauto_backend/donnees/depots/depot_entretien_postgresql.dart';

void main() {
  late ConnexionPostgresql connexionPostgresql;
  late DepotEntretienPostgresql depotEntretien;

  late String utilisateurId;
  late String autreUtilisateurId;
  late String vehiculeId;
  late String vehiculeAutreUtilisateurId;
  late String entretienId;

  const uuid = Uuid();

  setUpAll(() async {
    connexionPostgresql = ConnexionPostgresql();

    await connexionPostgresql.ouvrir();

    depotEntretien = DepotEntretienPostgresql(
      connexionPostgresql: connexionPostgresql,
    );

    utilisateurId = uuid.v4();
    autreUtilisateurId = uuid.v4();
    vehiculeId = uuid.v4();
    vehiculeAutreUtilisateurId = uuid.v4();

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
        'nom': 'Utilisateur Test Entretien',
        'email': 'test-entretien-$utilisateurId@gestauto.com',
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
        'id': autreUtilisateurId,
        'nom': 'Autre Utilisateur Test',
        'email': 'autre-entretien-$autreUtilisateurId@gestauto.com',
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
        'type': 'voiture',
        'marque': 'Toyota',
        'modele': 'Corolla',
        'immatriculation': 'TEST-${vehiculeId.substring(0, 8)}',
        'annee': 2024,
        'kilometrage': 15000,
        'dateAcquisition': DateTime(2024, 1, 15),
        'prixAcquisition': 12500000,
        'statut': 'enService',
        'montantVersementAttendu': 20000,
        'photo': null,
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
        'id': vehiculeAutreUtilisateurId,
        'utilisateurId': autreUtilisateurId,
        'type': 'voiture',
        'marque': 'Toyota',
        'modele': 'Yaris',
        'immatriculation':
            'AUTRE-${vehiculeAutreUtilisateurId.substring(0, 8)}',
        'annee': 2024,
        'kilometrage': 10000,
        'dateAcquisition': DateTime(2024, 1, 15),
        'prixAcquisition': 10000000,
        'statut': 'enService',
        'montantVersementAttendu': 20000,
        'photo': null,
      },
    );
  });

  tearDownAll(() async {
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
        DELETE FROM vehicules
        WHERE id = @id
        ''',
      ),
      parameters: {
        'id': vehiculeAutreUtilisateurId,
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

    await connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM utilisateurs
        WHERE id = @id
        ''',
      ),
      parameters: {
        'id': autreUtilisateurId,
      },
    );

    await connexionPostgresql.fermer();
  });

  test(
    'crée un entretien pour un véhicule autorisé',
    () async {
      final entretien = Entretien(
        id: uuid.v4(),
        vehiculeId: vehiculeId,
        type: 'Vidange',
        date: DateTime(2026, 8, 4),
        kilometrage: 25000,
        montant: 30000,
        prochainKilometrage: 35000,
        prochaineDate: DateTime(2026, 11, 4),
        notes: 'Vidange moteur et remplacement du filtre.',
      );

      final entretienCree =
          await depotEntretien.creer(
        utilisateurId: utilisateurId,
        entretien: entretien,
      );

      entretienId = entretienCree.id;

      expect(entretienCree.id, equals(entretien.id));
      expect(
        entretienCree.vehiculeId,
        equals(vehiculeId),
      );
      expect(
        entretienCree.type,
        equals('Vidange'),
      );
      expect(
        entretienCree.montant,
        equals(30000),
      );
    },
  );

  test(
    'récupère tous les entretiens de l utilisateur',
    () async {
      final entretiens =
          await depotEntretien.obtenirTous(
        utilisateurId: utilisateurId,
      );

      expect(entretiens, isNotEmpty);
      expect(
        entretiens.any(
          (entretien) => entretien.id == entretienId,
        ),
        isTrue,
      );
    },
  );

  test(
    'récupère les entretiens d un véhicule',
    () async {
      final entretiens =
          await depotEntretien.obtenirParVehicule(
        utilisateurId: utilisateurId,
        vehiculeId: vehiculeId,
      );

      expect(entretiens, isNotEmpty);
      expect(
        entretiens.every(
          (entretien) =>
              entretien.vehiculeId == vehiculeId,
        ),
        isTrue,
      );
    },
  );

  test(
    'récupère un entretien par son identifiant',
    () async {
      final entretien =
          await depotEntretien.obtenirParId(
        utilisateurId: utilisateurId,
        entretienId: entretienId,
      );

      expect(entretien, isNotNull);
      expect(entretien!.id, equals(entretienId));
      expect(
        entretien.vehiculeId,
        equals(vehiculeId),
      );
    },
  );

  test(
    'modifie un entretien existant',
    () async {
      final entretienModifie = Entretien(
        id: entretienId,
        vehiculeId: vehiculeId,
        type: 'Révision complète',
        date: DateTime(2026, 8, 4),
        kilometrage: 25500,
        montant: 45000,
        prochainKilometrage: 35500,
        prochaineDate: DateTime(2026, 12, 4),
        notes: 'Révision complète après vidange.',
      );

      final resultat =
          await depotEntretien.modifier(
        utilisateurId: utilisateurId,
        entretien: entretienModifie,
      );

      expect(
        resultat.type,
        equals('Révision complète'),
      );
      expect(
        resultat.kilometrage,
        equals(25500),
      );
      expect(
        resultat.montant,
        equals(45000),
      );
    },
  );

  test(
    'refuse la création avec le véhicule d un autre utilisateur',
    () async {
      final entretien = Entretien(
        id: uuid.v4(),
        vehiculeId: vehiculeAutreUtilisateurId,
        type: 'Vidange',
        date: DateTime(2026, 8, 4),
        kilometrage: 10000,
        montant: 20000,
      );

      expect(
        () => depotEntretien.creer(
          utilisateurId: utilisateurId,
          entretien: entretien,
        ),
        throwsA(
          isA<StateError>(),
        ),
      );
    },
  );

  test(
    'refuse la modification avec le véhicule d un autre utilisateur',
    () async {
      final entretien =
          await depotEntretien.obtenirParId(
        utilisateurId: utilisateurId,
        entretienId: entretienId,
      );

      expect(entretien, isNotNull);

      final entretienModifie = Entretien(
        id: entretienId,
        vehiculeId: vehiculeAutreUtilisateurId,
        type: entretien!.type,
        date: entretien.date,
        kilometrage: entretien.kilometrage,
        montant: entretien.montant,
        prochainKilometrage:
            entretien.prochainKilometrage,
        prochaineDate: entretien.prochaineDate,
        notes: entretien.notes,
      );

      expect(
        () => depotEntretien.modifier(
          utilisateurId: utilisateurId,
          entretien: entretienModifie,
        ),
        throwsA(
          isA<StateError>(),
        ),
      );
    },
  );

  test(
    'supprime un entretien',
    () async {
      await depotEntretien.supprimer(
        utilisateurId: utilisateurId,
        entretienId: entretienId,
      );

      final entretien =
          await depotEntretien.obtenirParId(
        utilisateurId: utilisateurId,
        entretienId: entretienId,
      );

      expect(entretien, isNull);
    },
  );
}