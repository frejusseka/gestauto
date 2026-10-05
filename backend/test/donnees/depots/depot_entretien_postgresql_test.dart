import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:gestauto_backend/coeur/base_de_donnees/connexion_postgresql.dart';
import 'package:gestauto_backend/domaine/entites/entretien.dart';
import 'package:gestauto_backend/donnees/depots/depot_entretien_postgresql.dart';

void main() {
  late ConnexionPostgresql connexionPostgresql;
  late DepotEntretienPostgresql depotEntretien;

  const utilisateurId =
      '248e6915-ac22-4e36-8139-da3c94b27f5a';

  const vehiculeId =
      'e59b81e1-c150-4035-bf40-b124606c62e5';

  const vehiculeAutreUtilisateurId =
      '11396195-ca2c-4c30-ae3a-fd12a5fd6176';

  late String entretienId;

  setUpAll(() async {
    connexionPostgresql = ConnexionPostgresql();

    await connexionPostgresql.ouvrir();

    depotEntretien = DepotEntretienPostgresql(
      connexionPostgresql: connexionPostgresql,
    );
  });

  tearDownAll(() async {
    await connexionPostgresql.fermer();
  });

  test(
    'crée un entretien pour un véhicule autorisé',
    () async {
      final entretien = Entretien(
        id: const Uuid().v4(),
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
        id: const Uuid().v4(),
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