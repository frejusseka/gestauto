import 'package:flutter/material.dart';

import '../../coeur/di/dependances.dart';
import '../../coeur/theme/controleur_theme.dart';
import '../accueil/page_accueil.dart';
import '../authentification/page_connexion.dart';
import '../depenses/page_depenses.dart';
import '../pannes/page_pannes.dart';
import '../vehicules/page_vehicules.dart';
import '../versements/page_versements.dart';

class PageNavigationPrincipale extends StatefulWidget {
  final ControleurTheme controleurTheme;

  const PageNavigationPrincipale({
    super.key,
    required this.controleurTheme,
  });

  @override
  State<PageNavigationPrincipale> createState() =>
      _PageNavigationPrincipaleState();
}

class _PageNavigationPrincipaleState
    extends State<PageNavigationPrincipale> {
  int _indexSelectionne = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    final controleurVehicules =
        Dependances.creerControleurVehicules();

    _pages = [
      PageAccueil(
        controleur:
            Dependances.creerControleurTableauDeBord(),
        controleurTheme:
            widget.controleurTheme,
        deconnecter: _deconnecter,
      ),
      PageVehicules(
        controleur: controleurVehicules,
      ),
      PageVersements(
        controleur:
            Dependances.creerControleurVersements(),
        controleurVehicules:
            controleurVehicules,
      ),
      PageDepenses(
        controleur:
            Dependances.creerControleurDepenses(),
        controleurCategories:
            Dependances
                .creerControleurCategoriesDepenses(),
        controleurVehicules:
            controleurVehicules,
      ),
      PagePannes(
        controleur:
            Dependances.creerControleurPannes(),
        controleurVehicules:
            controleurVehicules,
      ),
    ];
  }

  Future<void> _deconnecter() async {
    await Dependances.stockageSession.supprimerJeton();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => PageConnexion(
          connecterUtilisateur:
              Dependances.creerConnecterUtilisateur(),
          inscrireUtilisateur:
              Dependances.creerInscrireUtilisateur(),
          controleurTheme:
              widget.controleurTheme,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indexSelectionne,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexSelectionne,
        onDestinationSelected: (index) {
          setState(() {
            _indexSelectionne = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.directions_car_outlined,
            ),
            selectedIcon: Icon(
              Icons.directions_car,
            ),
            label: 'Véhicules',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: 'Versements',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.receipt_long_outlined,
            ),
            selectedIcon: Icon(
              Icons.receipt_long,
            ),
            label: 'Dépenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build),
            label: 'Pannes',
          ),
        ],
      ),
    );
  }
}