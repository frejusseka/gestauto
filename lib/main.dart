import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'coeur/di/dependances.dart';
import 'coeur/theme/controleur_theme.dart';
import 'coeur/theme/theme_gestauto.dart';
import 'presentation/authentification/page_connexion.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final controleurTheme = ControleurTheme();

  await controleurTheme.charger();

  runApp(
    Gestauto(
      controleurTheme: controleurTheme,
    ),
  );
}

class Gestauto extends StatelessWidget {
  final ControleurTheme controleurTheme;

  const Gestauto({
    super.key,
    required this.controleurTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controleurTheme,
      builder: (context, _) {
        final connecterUtilisateur =
            Dependances.creerConnecterUtilisateur();

        final inscrireUtilisateur =
            Dependances.creerInscrireUtilisateur();

        return MaterialApp(
          title: 'GESTAUTO',
          debugShowCheckedModeBanner: false,
          theme: ThemeGestauto.obtenir(),
          darkTheme: ThemeGestauto.obtenirSombre(),
          themeMode: controleurTheme.mode,
          home: PageConnexion(
            connecterUtilisateur:
                connecterUtilisateur,
            inscrireUtilisateur:
                inscrireUtilisateur,
            controleurTheme: controleurTheme,
          ),
        );
      },
    );
  }
}