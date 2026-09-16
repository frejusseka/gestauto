import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/cas_utilisation/ajouter_vehicule.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/donnees/depots/depot_vehicule_impl.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante_memoire.dart';

void main() {
  late AjouterVehicule ajouterVehicule;
  late DepotVehiculeImpl depot;

  setUp(() {
    final source = SourceVehiculeDistanteMemoire();

    depot = DepotVehiculeImpl(
      sourceDistante: source,
    );

    ajouterVehicule = AjouterVehicule(
      depot: depot,
    );
  });

  test('le cas d utilisation ajoute correctement un véhicule', () async {
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

    await ajouterVehicule.executer(vehicule);

    final vehicules = await depot.obtenirTous();

    expect(vehicules.length, 1);
    expect(vehicules.first.id, 'vehicule-1');
    expect(vehicules.first.marque, 'Yamaha');
  });
}