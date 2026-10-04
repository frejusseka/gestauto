import 'package:flutter/material.dart';

import '../../coeur/di/dependances.dart';
import '../accueil/page_accueil.dart';
import '../vehicules/page_vehicules.dart';
import '../versements/page_versements.dart';

class PageNavigationPrincipale extends StatefulWidget {
  const PageNavigationPrincipale({
    super.key,
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

    _pages = [
      PageAccueil(
        controleur:
            Dependances.creerControleurTableauDeBord(),
      ),
      PageVehicules(
        controleur:
            Dependances.creerControleurVehicules(),
      ),
      PageVersements(
        controleur:
            Dependances.creerControleurVersements(),
        controleurVehicules:
            Dependances.creerControleurVehicules(),
      ),
      const _PageProvisoire(
        titre: 'Activité',
        icone: Icons.bar_chart_outlined,
      ),
      const _PageProvisoire(
        titre: 'Plus',
        icone: Icons.menu,
      ),
    ];
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
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Activité',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_outlined),
            selectedIcon: Icon(Icons.menu),
            label: 'Plus',
          ),
        ],
      ),
    );
  }
}

class _PageProvisoire extends StatelessWidget {
  final String titre;
  final IconData icone;

  const _PageProvisoire({
    required this.titre,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titre),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icone,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              titre,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cette section sera développée prochainement.',
            ),
          ],
        ),
      ),
    );
  }
}