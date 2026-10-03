import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/cas_utilisation/supprimer_vehicule.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/donnees/depots/depot_vehicule_impl.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante_memoire.dart';

void main() {
  late SupprimerVehicule supprimerVehicule;
  late DepotVehiculeImpl depot;

  setUp(() {
    final source = SourceVehiculeDistanteMemoire();

    depot = DepotVehiculeImpl(
      sourceDistante: source,
    );

    supprimerVehicule = SupprimerVehicule(
      depot: depot,
    );
  });

  test('le cas d utilisation supprime correctement un véhicule', () async {
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

    await supprimerVehicule.executer('vehicule-1');

    final resultat = await depot.obtenirParId('vehicule-1');

    expect(resultat, isNull);
  });
}