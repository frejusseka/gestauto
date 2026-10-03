import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/donnees/modeles/vehicule_modele.dart';

void main() {
  test('fromJson doit créer correctement un modèle de véhicule', () {
    final json = {
      'id': 'vehicule-1',
      'type': 'voiture',
      'marque': 'Toyota',
      'modele': 'Yaris',
      'immatriculation': '1234 AB 01',
      'annee': 2022,
      'kilometrage': 85000,
      'dateAcquisition': '2024-05-10T00:00:00.000',
      'prixAcquisition': 8500000,
      'statut': 'enService',
      'montantVersementAttendu': 20000,
      'photo': 'toyota-yaris.jpg',
    };

    final modele = VehiculeModele.fromJson(json);

    expect(modele.id, 'vehicule-1');
    expect(modele.type, TypeVehicule.voiture);
    expect(modele.marque, 'Toyota');
    expect(modele.modele, 'Yaris');
    expect(modele.immatriculation, '1234 AB 01');
    expect(modele.annee, 2022);
    expect(modele.kilometrage, 85000);
    expect(
      modele.dateAcquisition,
      DateTime(2024, 5, 10),
    );
    expect(modele.prixAcquisition, 8500000);
    expect(modele.statut, StatutVehicule.enService);
    expect(modele.montantVersementAttendu, 20000);
    expect(modele.photo, 'toyota-yaris.jpg');
  });

  test('toJson doit convertir correctement un modèle en JSON', () {
    final modele = VehiculeModele(
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
      photo: 'xmax.jpg',
    );

    final json = modele.toJson();

    expect(json['id'], 'vehicule-1');
    expect(json['type'], 'moto');
    expect(json['marque'], 'Yamaha');
    expect(json['modele'], 'XMAX');
    expect(json['immatriculation'], '5678 CD 01');
    expect(json['annee'], 2023);
    expect(json['kilometrage'], 45000);
    expect(
      json['dateAcquisition'],
      '2025-02-15T00:00:00.000',
    );
    expect(json['prixAcquisition'], 2500000);
    expect(json['statut'], 'enService');
    expect(json['montantVersementAttendu'], 20000);
    expect(json['photo'], 'xmax.jpg');
  });

  test('toEntite doit convertir correctement le modèle en entité', () {
    final modele = VehiculeModele(
      id: 'vehicule-1',
      type: TypeVehicule.voiture,
      marque: 'Toyota',
      modele: 'Yaris',
      immatriculation: '1234 AB 01',
      annee: 2022,
      kilometrage: 85000,
      dateAcquisition: DateTime(2024, 5, 10),
      prixAcquisition: 8500000,
      statut: StatutVehicule.enMaintenance,
      montantVersementAttendu: 20000,
    );

    final entite = modele.toEntite();

    expect(entite, isA<Vehicule>());
    expect(entite.id, 'vehicule-1');
    expect(entite.type, TypeVehicule.voiture);
    expect(entite.marque, 'Toyota');
    expect(entite.modele, 'Yaris');
    expect(entite.kilometrage, 85000);
    expect(entite.statut, StatutVehicule.enMaintenance);
  });

  test('fromEntite doit convertir correctement une entité en modèle', () {
    final entite = Vehicule(
      id: 'vehicule-1',
      type: TypeVehicule.moto,
      marque: 'Yamaha',
      modele: 'XMAX',
      immatriculation: '5678 CD 01',
      annee: 2023,
      kilometrage: 45000,
      dateAcquisition: DateTime(2025, 2, 15),
      prixAcquisition: 2500000,
      statut: StatutVehicule.disponible,
      montantVersementAttendu: 20000,
      photo: 'xmax.jpg',
    );

    final modele = VehiculeModele.fromEntite(entite);

    expect(modele.id, 'vehicule-1');
    expect(modele.type, TypeVehicule.moto);
    expect(modele.marque, 'Yamaha');
    expect(modele.modele, 'XMAX');
    expect(modele.kilometrage, 45000);
    expect(modele.statut, StatutVehicule.disponible);
    expect(modele.photo, 'xmax.jpg');
  });
}