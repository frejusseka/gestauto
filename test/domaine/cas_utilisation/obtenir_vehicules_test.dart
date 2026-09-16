import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/cas_utilisation/obtenir_vehicules.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/donnees/depots/depot_vehicule_impl.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante_memoire.dart';

void main() {
  late ObtenirVehicules obtenirVehicules;
  late DepotVehiculeImpl depot;

  setUp(() {
    final source = SourceVehiculeDistanteMemoire();

    depot = DepotVehiculeImpl(
      sourceDistante: source,
    );

    obtenirVehicules = ObtenirVehicules(
      depot: depot,
    );
  });

  test('le cas d utilisation retourne tous les véhicules', () async {
    final vehicule = Vehicule(
      id: 'vehicule-1',
      type: TypeVehicule.voiture,
      marque: 'Toyota',
      modele: 'Yaris',
      immatriculation: '1234 AB 01',
      annee: 2022,
      kilometrage: 85000,
      dateAcquisition: DateTime(2024, 5, 10),
      prixAcquisition: 8500000,
      statut: StatutVehicule.enService,
      montantVersementAttendu: 20000,
    );

    await depot.ajouter(vehicule);

    final resultats = await obtenirVehicules.executer();

    expect(resultats.length, 1);
    expect(resultats.first.id, 'vehicule-1');
    expect(resultats.first.marque, 'Toyota');
  });

  test(
    'le cas d utilisation retourne une liste vide si aucun véhicule existe',
    () async {
      final resultats = await obtenirVehicules.executer();

      expect(resultats, isEmpty);
    },
  );
}