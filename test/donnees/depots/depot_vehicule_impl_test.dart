import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/donnees/depots/depot_vehicule_impl.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante_memoire.dart';
import 'package:gestauto/donnees/sources/locales/source_vehicule_locale.dart';

void main() {
  late Directory repertoireTest;
  late DepotVehiculeImpl depot;
  late Vehicule vehicule;

  setUpAll(() async {
    repertoireTest = await Directory.systemTemp.createTemp(
      'gestauto_hive_depot_test_',
    );

    Hive.init(repertoireTest.path);
  });

  setUp(() async {
    final source = SourceVehiculeDistanteMemoire();
    final sourceLocale = SourceVehiculeLocale();

    await sourceLocale.vider();

    depot = DepotVehiculeImpl(
      sourceDistante: source,
      sourceLocale: sourceLocale,
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
    'le dépôt peut ajouter et récupérer un véhicule',
    () async {
      await depot.ajouter(vehicule);

      final resultat =
          await depot.obtenirParId('vehicule-1');

      expect(resultat, isNotNull);
      expect(resultat!.marque, 'Yamaha');
      expect(resultat.modele, 'XMAX');
    },
  );

  test(
    'le dépôt peut récupérer tous les véhicules',
    () async {
      await depot.ajouter(vehicule);

      final vehicules =
          await depot.obtenirTous();

      expect(vehicules.length, 1);
      expect(vehicules.first.id, 'vehicule-1');
    },
  );

  test(
    'le dépôt peut modifier un véhicule',
    () async {
      await depot.ajouter(vehicule);

      final vehiculeModifie = Vehicule(
        id: 'vehicule-1',
        type: TypeVehicule.moto,
        marque: 'Yamaha',
        modele: 'XMAX',
        immatriculation: '5678 CD 01',
        annee: 2023,
        kilometrage: 50000,
        dateAcquisition: DateTime(2025, 2, 15),
        prixAcquisition: 2500000,
        statut: StatutVehicule.enMaintenance,
        montantVersementAttendu: 20000,
      );

      await depot.modifier(
        vehiculeModifie,
      );

      final resultat =
          await depot.obtenirParId('vehicule-1');

      expect(resultat, isNotNull);
      expect(resultat!.kilometrage, 50000);
      expect(
        resultat.statut,
        StatutVehicule.enMaintenance,
      );
    },
  );

  test(
    'le dépôt peut supprimer un véhicule',
    () async {
      await depot.ajouter(vehicule);

      await depot.supprimer('vehicule-1');

      final resultat =
          await depot.obtenirParId('vehicule-1');

      expect(resultat, isNull);
    },
  );

  test(
    'le dépôt utilise le cache si la source distante échoue',
    () async {
      final sourceDistante =
          SourceVehiculeDistanteMemoire();

      final sourceLocale =
          SourceVehiculeLocale();

      final depotAvecApi =
          DepotVehiculeImpl(
        sourceDistante: sourceDistante,
        sourceLocale: sourceLocale,
      );

      await depotAvecApi.ajouter(vehicule);

      final depotHorsLigne =
          DepotVehiculeImpl(
        sourceDistante:
            SourceVehiculeDistanteEnErreur(),
        sourceLocale: sourceLocale,
      );

      final vehicules =
          await depotHorsLigne.obtenirTous();

      expect(vehicules.length, 1);
      expect(vehicules.first.id, 'vehicule-1');
      expect(vehicules.first.marque, 'Yamaha');
    },
  );
}

class SourceVehiculeDistanteEnErreur
    implements SourceVehiculeDistante {
  @override
  Future<List<Vehicule>> obtenirTous() async {
    throw Exception(
      'Serveur indisponible',
    );
  }

  @override
  Future<Vehicule?> obtenirParId(
    String id,
  ) async {
    throw Exception(
      'Serveur indisponible',
    );
  }

  @override
  Future<Vehicule> ajouter(
    Vehicule vehicule,
  ) async {
    throw Exception(
      'Serveur indisponible',
    );
  }

  @override
  Future<void> modifier(
    Vehicule vehicule,
  ) async {
    throw Exception(
      'Serveur indisponible',
    );
  }

  @override
  Future<void> supprimer(
    String id,
  ) async {
    throw Exception(
      'Serveur indisponible',
    );
  }
}