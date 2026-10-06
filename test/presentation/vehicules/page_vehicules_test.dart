import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gestauto/domaine/cas_utilisation/ajouter_vehicule.dart';
import 'package:gestauto/domaine/cas_utilisation/obtenir_vehicules.dart';
import 'package:gestauto/domaine/depots/depot_vehicule.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/presentation/vehicules/controleur_vehicules.dart';
import 'package:gestauto/presentation/vehicules/page_vehicules.dart';

class _DepotVehiculeFictif
    implements DepotVehicule {
  final List<Vehicule> vehicules;
  final bool provoquerErreur;

  _DepotVehiculeFictif({
    this.vehicules = const [],
    this.provoquerErreur = false,
  });

  @override
  Future<List<Vehicule>> obtenirTous() async {
    if (provoquerErreur) {
      throw Exception('Erreur réseau');
    }

    return vehicules;
  }

  @override
  Future<Vehicule?> obtenirParId(String id) async {
    return null;
  }

  @override
  Future<Vehicule> ajouter(
    Vehicule vehicule,
  ) async {
    return vehicule;
  }

  @override
  Future<void> modifier(
    Vehicule vehicule,
  ) async {}

  @override
  Future<void> supprimer(
    String id,
  ) async {}
}

Vehicule _creerVehicule() {
  return Vehicule(
    id: 'vehicule-test-1',
    type: TypeVehicule.voiture,
    marque: 'Toyota',
    modele: 'Corolla',
    immatriculation: 'AB-1234-CD',
    annee: 2022,
    kilometrage: 45000,
    dateAcquisition: DateTime(2024, 1, 15),
    prixAcquisition: 8500000,
    statut: StatutVehicule.enService,
    montantVersementAttendu: 20000,
  );
}

ControleurVehicules _creerControleur({
  List<Vehicule> vehicules = const [],
  bool provoquerErreur = false,
}) {
  final depot = _DepotVehiculeFictif(
    vehicules: vehicules,
    provoquerErreur: provoquerErreur,
  );

  return ControleurVehicules(
    obtenirVehicules: ObtenirVehicules(
      depot: depot,
    ),
    ajouterVehicule: AjouterVehicule(
      depot: depot,
    ),
  );
}

Future<void> _afficherPage(
  WidgetTester tester,
  ControleurVehicules controleur,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: PageVehicules(
        controleur: controleur,
      ),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'la page affiche un véhicule chargé',
    (tester) async {
      final vehicule = _creerVehicule();

      final controleur = _creerControleur(
        vehicules: [vehicule],
      );

      await _afficherPage(
        tester,
        controleur,
      );

      expect(
        find.text('Mes véhicules'),
        findsOneWidget,
      );

      expect(
        find.text('Toyota Corolla'),
        findsOneWidget,
      );

      expect(
        find.text('AB-1234-CD'),
        findsOneWidget,
      );

      expect(
        find.text('En service'),
        findsOneWidget,
      );

      expect(
        find.text('45000 km'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'la page affiche un message lorsque aucun véhicule n est enregistré',
    (tester) async {
      final controleur = _creerControleur();

      await _afficherPage(
        tester,
        controleur,
      );

      expect(
        find.text('Aucun véhicule'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Vous n’avez encore enregistré aucun véhicule.',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Ajouter un véhicule'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'la page affiche une erreur lorsque le chargement échoue',
    (tester) async {
      final controleur = _creerControleur(
        provoquerErreur: true,
      );

      await _afficherPage(
        tester,
        controleur,
      );

      expect(
        find.text(
          'Impossible de charger les véhicules.',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Réessayer'),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.cloud_off_outlined),
        findsOneWidget,
      );
    },
  );
}