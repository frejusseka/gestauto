import 'package:flutter/material.dart';

import 'coeur/di/dependances.dart';
import 'coeur/theme/theme_gestauto.dart';
import 'presentation/authentification/page_connexion.dart';

void main() {
  runApp(const Gestauto());
}

class Gestauto extends StatelessWidget {
  const Gestauto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final connecterUtilisateur =
        Dependances.creerConnecterUtilisateur();

    final inscrireUtilisateur =
        Dependances.creerInscrireUtilisateur();

    final controleurTableauDeBord =
        Dependances.creerControleurTableauDeBord();

    return MaterialApp(
      title: 'GESTAUTO',
      debugShowCheckedModeBanner: false,
      theme: ThemeGestauto.obtenir(),
      home: PageConnexion(
        connecterUtilisateur: connecterUtilisateur,
        inscrireUtilisateur: inscrireUtilisateur,
        controleurTableauDeBord:
            controleurTableauDeBord,
      ),
    );
  }
}