import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gestauto/domaine/cas_utilisation/ajouter_vehicule.dart';
import 'package:gestauto/domaine/cas_utilisation/creer_versement.dart';
import 'package:gestauto/domaine/cas_utilisation/obtenir_vehicules.dart';
import 'package:gestauto/domaine/cas_utilisation/obtenir_versements.dart';
import 'package:gestauto/domaine/depots/depot_vehicule.dart';
import 'package:gestauto/domaine/depots/depot_versement.dart';
import 'package:gestauto/domaine/entites/resultat_vehicules.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/domaine/entites/versement.dart';
import 'package:gestauto/presentation/vehicules/controleur_vehicules.dart';
import 'package:gestauto/presentation/versements/controleur_versements.dart';
import 'package:gestauto/presentation/versements/page_versements.dart';

class _DepotVehiculeFictif
    implements DepotVehicule {
  final List<Vehicule> vehicules;

  _DepotVehiculeFictif({
    this.vehicules = const [],
  });

  @override
  Future<ResultatVehicules> obtenirTous() async {
    return ResultatVehicules(
      vehicules: vehicules,
      sourceLocale: false,
    );
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

class _DepotVersementFictif
    implements DepotVersement {
  final List<Versement> versements;
  final bool provoquerErreur;

  _DepotVersementFictif({
    this.versements = const [],
    this.provoquerErreur = false,
  });

  @override
  Future<List<Versement>> obtenirTous() async {
    if (provoquerErreur) {
      throw Exception('Erreur réseau');
    }

    return versements;
  }

  @override
  Future<Versement> creer({
    required String vehiculeId,
    required DateTime date,
    required double montantAttendu,
    required double montantVerse,
  }) async {
    return Versement(
      id: 'versement-test-nouveau',
      vehiculeId: vehiculeId,
      date: date,
      montantAttendu: montantAttendu,
      montantVerse: montantVerse,
    );
  }
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

Versement _creerVersement({
  required double montantAttendu,
  required double montantVerse,
}) {
  return Versement(
    id: 'versement-test-1',
    vehiculeId: 'vehicule-test-1',
    date: DateTime(2026, 10, 6),
    montantAttendu: montantAttendu,
    montantVerse: montantVerse,
  );
}

ControleurVehicules _creerControleurVehicules({
  required List<Vehicule> vehicules,
}) {
  final depot = _DepotVehiculeFictif(
    vehicules: vehicules,
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

ControleurVersements _creerControleurVersements({
  List<Versement> versements = const [],
  bool provoquerErreur = false,
}) {
  final depot = _DepotVersementFictif(
    versements: versements,
    provoquerErreur: provoquerErreur,
  );

  return ControleurVersements(
    obtenirVersements: ObtenirVersements(
      depot: depot,
    ),
    creerVersement: CreerVersement(
      depot: depot,
    ),
  );
}

Future<void> _afficherPage(
  WidgetTester tester, {
  required ControleurVersements controleurVersements,
  required ControleurVehicules controleurVehicules,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: PageVersements(
        controleur: controleurVersements,
        controleurVehicules: controleurVehicules,
      ),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'la page affiche un versement conforme avec son véhicule',
    (tester) async {
      final vehicule = _creerVehicule();

      final versement = _creerVersement(
        montantAttendu: 20000,
        montantVerse: 20000,
      );

      final controleurVehicules =
          _creerControleurVehicules(
        vehicules: [vehicule],
      );

      final controleurVersements =
          _creerControleurVersements(
        versements: [versement],
      );

      await _afficherPage(
        tester,
        controleurVersements:
            controleurVersements,
        controleurVehicules:
            controleurVehicules,
      );

      expect(
        find.text('Versements'),
        findsOneWidget,
      );

      expect(
        find.text('Toyota Corolla'),
        findsOneWidget,
      );

      expect(
        find.text('Conforme'),
        findsOneWidget,
      );

      expect(
        find.text('20 000 FCFA'),
        findsNWidgets(2),
      );

      expect(
        find.text('0 FCFA'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'la page affiche un versement en infraction',
    (tester) async {
      final vehicule = _creerVehicule();

      final versement = _creerVersement(
        montantAttendu: 20000,
        montantVerse: 15000,
      );

      final controleurVehicules =
          _creerControleurVehicules(
        vehicules: [vehicule],
      );

      final controleurVersements =
          _creerControleurVersements(
        versements: [versement],
      );

      await _afficherPage(
        tester,
        controleurVersements:
            controleurVersements,
        controleurVehicules:
            controleurVehicules,
      );

      expect(
        find.text('Infraction'),
        findsOneWidget,
      );

      expect(
        find.text('20 000 FCFA'),
        findsOneWidget,
      );

      expect(
        find.text('15 000 FCFA'),
        findsOneWidget,
      );

      expect(
        find.text('5 000 FCFA'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'la page affiche un état vide lorsqu aucun versement existe',
    (tester) async {
      final controleurVehicules =
          _creerControleurVehicules(
        vehicules: [_creerVehicule()],
      );

      final controleurVersements =
          _creerControleurVersements();

      await _afficherPage(
        tester,
        controleurVersements:
            controleurVersements,
        controleurVehicules:
            controleurVehicules,
      );

      expect(
        find.text('Aucun versement'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Enregistrez votre premier versement.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'la page affiche une erreur lorsque le chargement échoue',
    (tester) async {
      final controleurVehicules =
          _creerControleurVehicules(
        vehicules: [_creerVehicule()],
      );

      final controleurVersements =
          _creerControleurVersements(
        provoquerErreur: true,
      );

      await _afficherPage(
        tester,
        controleurVersements:
            controleurVersements,
        controleurVehicules:
            controleurVehicules,
      );

      expect(
        find.text(
          'Impossible de charger les versements.',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Réessayer'),
        findsOneWidget,
      );

      expect(
        find.byIcon(
          Icons.cloud_off_outlined,
        ),
        findsOneWidget,
      );
    },
  );
}