import 'package:flutter/material.dart';

import 'coeur/di/dependances.dart';
import 'presentation/authentification/page_connexion.dart';

void main() {
  runApp(const Gestauto());
}

class Gestauto extends StatelessWidget {
  const Gestauto({super.key});

  @override
  Widget build(BuildContext context) {
    final connecterUtilisateur =
        Dependances.creerConnecterUtilisateur();

    final inscrireUtilisateur =
        Dependances.creerInscrireUtilisateur();

    return MaterialApp(
      title: 'GESTAUTO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: PageConnexion(
        connecterUtilisateur: connecterUtilisateur,
        inscrireUtilisateur: inscrireUtilisateur,
      ),
    );
  }
}