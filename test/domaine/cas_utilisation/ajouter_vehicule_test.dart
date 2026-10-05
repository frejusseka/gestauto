import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:gestauto/donnees/depots/depot_vehicule_impl.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante_memoire.dart';
import 'package:gestauto/donnees/sources/locales/source_vehicule_locale.dart';
import 'package:gestauto/domaine/cas_utilisation/ajouter_vehicule.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';

void main() {
  late Directory repertoireTest;
  late AjouterVehicule ajouterVehicule;
  late DepotVehiculeImpl depot;
  late Vehicule vehicule;

  setUpAll(() async {
    repertoireTest = await Directory.systemTemp.createTemp(
      'gestauto_ajouter_vehicule_test_',
    );

    Hive.init(repertoireTest.path);
  });

  setUp(() {
    final source = SourceVehiculeDistanteMemoire();
    final sourceLocale = SourceVehiculeLocale();

    depot = DepotVehiculeImpl(
      sourceDistante: source,
      sourceLocale: sourceLocale,
    );

    ajouterVehicule = AjouterVehicule(
      depot: depot,
    );

    vehicule = Vehicule(
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
  });

  tearDown(() async {
    final sourceLocale = SourceVehiculeLocale();

    await sourceLocale.vider();
  });

  tearDownAll(() async {
    await Hive.close();

    if (await repertoireTest.exists()) {
      await repertoireTest.delete(recursive: true);
    }
  });

  test(
    'le cas d’utilisation ajoute un véhicule',
    () async {
      final resultat =
          await ajouterVehicule.executer(vehicule);

      expect(resultat.id, 'vehicule-1');
      expect(resultat.marque, 'Yamaha');
      expect(resultat.modele, 'XMAX');
    },
  );
}