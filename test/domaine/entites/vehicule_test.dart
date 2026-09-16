import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';

void main() {
  test('un véhicule doit être créé avec les informations fournies', () {
    final vehicule = Vehicule(
      id: '1',
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

    expect(vehicule.id, '1');
    expect(vehicule.type, TypeVehicule.voiture);
    expect(vehicule.marque, 'Toyota');
    expect(vehicule.modele, 'Yaris');
    expect(vehicule.immatriculation, '1234 AB 01');
    expect(vehicule.annee, 2022);
    expect(vehicule.kilometrage, 85000);
    expect(vehicule.prixAcquisition, 8500000);
    expect(vehicule.statut, StatutVehicule.enService);
    expect(vehicule.montantVersementAttendu, 20000);
    expect(vehicule.photo, isNull);
  });
}