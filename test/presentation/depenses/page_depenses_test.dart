import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gestauto/domaine/cas_utilisation/ajouter_vehicule.dart';
import 'package:gestauto/domaine/cas_utilisation/creer_categorie_depense.dart';
import 'package:gestauto/domaine/cas_utilisation/creer_depense.dart';
import 'package:gestauto/domaine/cas_utilisation/obtenir_categories_depense.dart';
import 'package:gestauto/domaine/cas_utilisation/obtenir_depenses.dart';
import 'package:gestauto/domaine/cas_utilisation/obtenir_vehicules.dart';
import 'package:gestauto/domaine/depots/depot_categorie_depense.dart';
import 'package:gestauto/domaine/depots/depot_depense.dart';
import 'package:gestauto/domaine/depots/depot_vehicule.dart';
import 'package:gestauto/domaine/entites/categorie_depense.dart';
import 'package:gestauto/domaine/entites/depense.dart';
import 'package:gestauto/domaine/entites/resultat_vehicules.dart';
import 'package:gestauto/domaine/entites/vehicule.dart';
import 'package:gestauto/presentation/depenses/controleur_categories_depenses.dart';
import 'package:gestauto/presentation/depenses/controleur_depenses.dart';
import 'package:gestauto/presentation/depenses/page_depenses.dart';
import 'package:gestauto/presentation/vehicules/controleur_vehicules.dart';

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

class _DepotDepenseFictif
    implements DepotDepense {
  final List<Depense> depenses;
  final bool provoquerErreur;

  _DepotDepenseFictif({
    this.depenses = const [],
    this.provoquerErreur = false,
  });

  @override
  Future<List<Depense>> obtenirTous() async {
    if (provoquerErreur) {
      throw Exception('Erreur réseau');
    }

    return depenses;
  }

  @override
  Future<Depense> creer({
    required String vehiculeId,
    required String categorieId,
    required DateTime date,
    required double montant,
    String? description,
  }) async {
    return Depense(
      id: 'depense-test-nouvelle',
      vehiculeId: vehiculeId,
      categorieId: categorieId,
      date: date,
      montant: montant,
      description: description,
    );
  }
}

class _DepotCategorieDepenseFictif
    implements DepotCategorieDepense {
  final List<CategorieDepense> categories;

  _DepotCategorieDepenseFictif({
    this.categories = const [],
  });

  @override
  Future<List<CategorieDepense>> obtenirTous() async {
    return categories;
  }

  @override
  Future<CategorieDepense> creer({
    required String nom,
  }) async {
    return CategorieDepense(
      id: 'categorie-test-nouvelle',
      nom: nom,
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

CategorieDepense _creerCategorie() {
  return CategorieDepense(
    id: 'categorie-test-1',
    nom: 'Carburant',
  );
}

Depense _creerDepense() {
  return Depense(
    id: 'depense-test-1',
    vehiculeId: 'vehicule-test-1',
    categorieId: 'categorie-test-1',
    date: DateTime(2026, 10, 6),
    montant: 15000,
    description: 'Plein de carburant',
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

ControleurDepenses _creerControleurDepenses({
  List<Depense> depenses = const [],
  bool provoquerErreur = false,
}) {
  final depot = _DepotDepenseFictif(
    depenses: depenses,
    provoquerErreur: provoquerErreur,
  );

  return ControleurDepenses(
    obtenirDepenses: ObtenirDepenses(
      depot: depot,
    ),
    creerDepense: CreerDepense(
      depot: depot,
    ),
  );
}

ControleurCategoriesDepenses
    _creerControleurCategories({
  List<CategorieDepense> categories =
      const [],
}) {
  final depot =
      _DepotCategorieDepenseFictif(
    categories: categories,
  );

  return ControleurCategoriesDepenses(
    obtenirCategoriesDepense:
        ObtenirCategoriesDepense(
      depot: depot,
    ),
    creerCategorieDepense:
        CreerCategorieDepense(
      depot: depot,
    ),
  );
}

Future<void> _afficherPage(
  WidgetTester tester, {
  required ControleurDepenses
      controleurDepenses,
  required ControleurCategoriesDepenses
      controleurCategories,
  required ControleurVehicules
      controleurVehicules,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: PageDepenses(
        controleur: controleurDepenses,
        controleurCategories:
            controleurCategories,
        controleurVehicules:
            controleurVehicules,
      ),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'la page affiche une dépense avec son véhicule et sa catégorie',
    (tester) async {
      final vehicule = _creerVehicule();
      final categorie = _creerCategorie();
      final depense = _creerDepense();

      final controleurVehicules =
          _creerControleurVehicules(
        vehicules: [vehicule],
      );

      final controleurCategories =
          _creerControleurCategories(
        categories: [categorie],
      );

      final controleurDepenses =
          _creerControleurDepenses(
        depenses: [depense],
      );

      await _afficherPage(
        tester,
        controleurDepenses:
            controleurDepenses,
        controleurCategories:
            controleurCategories,
        controleurVehicules:
            controleurVehicules,
      );

      expect(
        find.text('Dépenses'),
        findsOneWidget,
      );

      expect(
        find.text('Carburant'),
        findsOneWidget,
      );

      expect(
        find.text('Toyota Corolla'),
        findsOneWidget,
      );

      expect(
        find.text('15000 FCFA'),
        findsOneWidget,
      );

      expect(
        find.text('Plein de carburant'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'la page affiche un état vide lorsqu aucune dépense existe',
    (tester) async {
      final controleurVehicules =
          _creerControleurVehicules(
        vehicules: [_creerVehicule()],
      );

      final controleurCategories =
          _creerControleurCategories(
        categories: [_creerCategorie()],
      );

      final controleurDepenses =
          _creerControleurDepenses();

      await _afficherPage(
        tester,
        controleurDepenses:
            controleurDepenses,
        controleurCategories:
            controleurCategories,
        controleurVehicules:
            controleurVehicules,
      );

      expect(
        find.text('Aucune dépense'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Enregistrez votre première dépense '
          'pour commencer le suivi.',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Ajouter une dépense'),
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

      final controleurCategories =
          _creerControleurCategories(
        categories: [_creerCategorie()],
      );

      final controleurDepenses =
          _creerControleurDepenses(
        provoquerErreur: true,
      );

      await _afficherPage(
        tester,
        controleurDepenses:
            controleurDepenses,
        controleurCategories:
            controleurCategories,
        controleurVehicules:
            controleurVehicules,
      );

      expect(
        find.text(
          'Impossible de charger les dépenses.',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Réessayer'),
        findsOneWidget,
      );

      expect(
        find.byIcon(
          Icons.error_outline,
        ),
        findsOneWidget,
      );
    },
  );
}