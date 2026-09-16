import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/donnees/depots/depot_vehicule_impl.dart';
import 'package:gestauto/donnees/sources/distantes/source_vehicule_distante_memoire.dart';

void main() {
  late DepotVehiculeImpl depot;
  late Vehicule vehicule;

  setUp(() {
    final source = SourceVehiculeDistanteMemoire();

    depot = DepotVehiculeImpl(
      sourceDistante: source,
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

  test('le dépôt peut ajouter et récupérer un véhicule', () async {
    await depot.ajouter(vehicule);

    final resultat = await depot.obtenirParId('vehicule-1');

    expect(resultat, isNotNull);
    expect(resultat!.marque, 'Yamaha');
    expect(resultat.modele, 'XMAX');
  });

  test('le dépôt peut récupérer tous les véhicules', () async {
    await depot.ajouter(vehicule);

    final vehicules = await depot.obtenirTous();

    expect(vehicules.length, 1);
    expect(vehicules.first.id, 'vehicule-1');
  });

  test('le dépôt peut modifier un véhicule', () async {
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

    await depot.modifier(vehiculeModifie);

    final resultat = await depot.obtenirParId('vehicule-1');

    expect(resultat, isNotNull);
    expect(resultat!.kilometrage, 50000);
    expect(resultat.statut, StatutVehicule.enMaintenance);
  });

  test('le dépôt peut supprimer un véhicule', () async {
    await depot.ajouter(vehicule);

    await depot.supprimer('vehicule-1');

    final resultat = await depot.obtenirParId('vehicule-1');

    expect(resultat, isNull);
  });
}