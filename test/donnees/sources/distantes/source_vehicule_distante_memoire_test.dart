import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante_memoire.dart';

void main() {
  late SourceVehiculeDistanteMemoire source;
  late Vehicule vehicule;

  setUp(() {
    source = SourceVehiculeDistanteMemoire();

    vehicule = Vehicule(
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
  });

  test('un véhicule peut être ajouté et récupéré', () async {
    await source.ajouter(vehicule);

    final vehicules = await source.obtenirTous();

    expect(vehicules.length, 1);
    expect(vehicules.first.id, 'vehicule-1');
    expect(vehicules.first.marque, 'Toyota');
  });

  test('un véhicule peut être récupéré par son identifiant', () async {
    await source.ajouter(vehicule);

    final resultat = await source.obtenirParId('vehicule-1');

    expect(resultat, isNotNull);
    expect(resultat!.id, 'vehicule-1');
  });

  test('un véhicule inexistant retourne null', () async {
    final resultat = await source.obtenirParId('vehicule-inexistant');

    expect(resultat, isNull);
  });

  test('un véhicule peut être modifié', () async {
    await source.ajouter(vehicule);

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

    await source.modifier(vehiculeModifie);

    final resultat = await source.obtenirParId('vehicule-1');

    expect(resultat, isNotNull);
    expect(resultat!.kilometrage, 90000);
    expect(resultat.statut, StatutVehicule.enMaintenance);
  });

  test('un véhicule peut être supprimé', () async {
    await source.ajouter(vehicule);

    await source.supprimer('vehicule-1');

    final resultat = await source.obtenirParId('vehicule-1');

    expect(resultat, isNull);
  });
}