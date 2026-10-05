import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:gestauto/donnees/modeles/vehicule_modele.dart';
import 'package:gestauto/donnees/sources/locales/source_vehicule_locale.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';

void main() {
  late Directory repertoireTest;
  late SourceVehiculeLocale sourceLocale;

  final vehicule = VehiculeModele(
    id: 'vehicule-1',
    type: TypeVehicule.moto,
    marque: 'Yamaha',
    modele: 'XMAX',
    immatriculation: '5678 CD 01',
    annee: 2023,
    kilometrage: 45000,
    dateAcquisition: DateTime(2025, 2, 15),
    prixAcquisition: 2500000,
    statut: StatutVehicule.enService,
    montantVersementAttendu: 20000,
  );

  setUpAll(() async {
    repertoireTest = await Directory.systemTemp.createTemp(
      'gestauto_hive_test_',
    );

    Hive.init(repertoireTest.path);
  });

  setUp(() async {
    sourceLocale = SourceVehiculeLocale();

    if (Hive.isBoxOpen('vehicules')) {
      await Hive.box<dynamic>('vehicules').clear();
    }
  });

  tearDownAll(() async {
    await Hive.close();

    if (await repertoireTest.exists()) {
      await repertoireTest.delete(recursive: true);
    }
  });

  test(
    'la source locale peut enregistrer et récupérer un véhicule',
    () async {
      await sourceLocale.enregistrer(vehicule);

      final resultat =
          await sourceLocale.obtenirParId('vehicule-1');

      expect(resultat, isNotNull);
      expect(resultat!.id, 'vehicule-1');
      expect(resultat.marque, 'Yamaha');
      expect(resultat.modele, 'XMAX');
    },
  );

  test(
    'la source locale peut récupérer tous les véhicules',
    () async {
      final autreVehicule = VehiculeModele(
        id: 'vehicule-2',
        type: TypeVehicule.voiture,
        marque: 'Toyota',
        modele: 'Corolla',
        immatriculation: '1234 AB 01',
        annee: 2022,
        kilometrage: 60000,
        dateAcquisition: DateTime(2024, 5, 10),
        prixAcquisition: 12000000,
        statut: StatutVehicule.disponible,
        montantVersementAttendu: 25000,
      );

      await sourceLocale.enregistrer(vehicule);
      await sourceLocale.enregistrer(autreVehicule);

      final vehicules =
          await sourceLocale.obtenirTous();

      expect(vehicules.length, 2);
      expect(
        vehicules.any(
          (element) => element.id == 'vehicule-1',
        ),
        isTrue,
      );
      expect(
        vehicules.any(
          (element) => element.id == 'vehicule-2',
        ),
        isTrue,
      );
    },
  );

  test(
    'la source locale peut supprimer un véhicule',
    () async {
      await sourceLocale.enregistrer(vehicule);

      await sourceLocale.supprimer('vehicule-1');

      final resultat =
          await sourceLocale.obtenirParId('vehicule-1');

      expect(resultat, isNull);
    },
  );

  test(
    'la source locale peut vider le cache',
    () async {
      await sourceLocale.enregistrer(vehicule);

      await sourceLocale.vider();

      final vehicules =
          await sourceLocale.obtenirTous();

      expect(vehicules, isEmpty);
    },
  );
}