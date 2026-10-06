import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:gestauto/donnees/depots/depot_vehicule_impl.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante_memoire.dart';
import 'package:gestauto/donnees/sources/locales/source_vehicule_locale.dart';
import 'package:gestauto/domaine/cas_utilisation/obtenir_vehicules.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';

void main() {
  late Directory repertoireTest;
  late ObtenirVehicules obtenirVehicules;
  late DepotVehiculeImpl depot;

  setUpAll(() async {
    repertoireTest = await Directory.systemTemp.createTemp(
      'gestauto_obtenir_vehicules_test_',
    );

    Hive.init(repertoireTest.path);
  });

  setUp(() {
    depot = DepotVehiculeImpl(
      sourceDistante:
          SourceVehiculeDistanteMemoire(),
      sourceLocale: SourceVehiculeLocale(),
    );

    obtenirVehicules = ObtenirVehicules(
      depot: depot,
    );
  });

  tearDown(() async {
    await SourceVehiculeLocale().vider();
  });

  tearDownAll(() async {
    await Hive.close();

    if (await repertoireTest.exists()) {
      await repertoireTest.delete(recursive: true);
    }
  });

  test(
    'le cas d’utilisation obtient les véhicules',
    () async {
      final vehicule = Vehicule(
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

      await depot.ajouter(vehicule);

      final resultat =
          await obtenirVehicules.executer();

      expect(resultat.vehicules.length, 1);
      expect(
        resultat.vehicules.first.id,
        'vehicule-1',
      );
      expect(resultat.sourceLocale, isFalse);
    },
  );
}