import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/cas_utilisation/modifier_vehicule.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/donnees/depots/depot_vehicule_impl.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante_memoire.dart';

void main() {
  late ModifierVehicule modifierVehicule;
  late DepotVehiculeImpl depot;

  setUp(() {
    final source = SourceVehiculeDistanteMemoire();

    depot = DepotVehiculeImpl(
      sourceDistante: source,
    );

    modifierVehicule = ModifierVehicule(
      depot: depot,
    );
  });

  test('le cas d utilisation modifie correctement un véhicule', () async {
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

    final vehiculeModifie = Vehicule(
      id: 'vehicule-1',
      type: TypeVehicule.voiture,
      marque: 'Toyota',
      modele: 'Yaris',
      immatriculation: '1234 AB 01',
      annee: 2022,
      kilometrage: 90000,
      dateAcquisition: DateTime(2024, 5, 10),
      prixAcquisition: 8500000,
      statut: StatutVehicule.enMaintenance,
      montantVersementAttendu: 20000,
    );

    await modifierVehicule.executer(vehiculeModifie);

    final resultat = await depot.obtenirParId('vehicule-1');

    expect(resultat, isNotNull);
    expect(resultat!.kilometrage, 90000);
    expect(resultat.statut, StatutVehicule.enMaintenance);
  });
}