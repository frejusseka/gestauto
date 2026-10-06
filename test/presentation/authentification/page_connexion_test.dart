import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gestauto/coeur/stockage/stockage_session.dart';
import 'package:gestauto/domaine/cas_utilisation/connecter_utilisateur.dart';
import 'package:gestauto/domaine/cas_utilisation/inscrire_utilisateur.dart';
import 'package:gestauto/domaine/depots/depot_authentification.dart';
import 'package:gestauto/domaine/entites/utilisateur.dart';
import 'package:gestauto/presentation/authentification/page_connexion.dart';

class _DepotAuthentificationFictif
    implements DepotAuthentification {
  @override
  Future<ResultatAuthentification> connecter({
    required String email,
    required String motDePasse,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Utilisateur> inscrire({
    required String nom,
    required String email,
    required String motDePasse,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deconnecter() {
    throw UnimplementedError();
  }
}

class _StockageSessionFictif extends StockageSession {}

PageConnexion _creerPageConnexion() {
  final depot = _DepotAuthentificationFictif();
  final stockageSession = _StockageSessionFictif();

  return PageConnexion(
    connecterUtilisateur: ConnecterUtilisateur(
      depot: depot,
      stockageSession: stockageSession,
    ),
    inscrireUtilisateur: InscrireUtilisateur(
      depot: depot,
    ),
  );
}

void main() {
  testWidgets(
    'la page de connexion affiche les éléments principaux',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: _creerPageConnexion(),
        ),
      );

      expect(
        find.text('Connexion'),
        findsOneWidget,
      );

      expect(
        find.text('GESTAUTO'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Gestion simple et efficace de votre flotte',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Adresse e-mail'),
        findsOneWidget,
      );

      expect(
        find.text('Mot de passe'),
        findsOneWidget,
      );

      expect(
        find.text('Se connecter'),
        findsOneWidget,
      );

      expect(
        find.text('Vous n’avez pas encore de compte ?'),
        findsOneWidget,
      );

      expect(
        find.text('Créer un compte'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'la validation affiche une erreur si les champs sont vides',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: _creerPageConnexion(),
        ),
      );

      await tester.tap(
        find.text('Se connecter'),
      );

      await tester.pump();

      expect(
        find.text(
          'Veuillez saisir votre adresse e-mail',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Veuillez saisir votre mot de passe',
        ),
        findsOneWidget,
      );
    },
  );
}