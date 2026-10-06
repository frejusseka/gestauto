import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gestauto/domaine/cas_utilisation/inscrire_utilisateur.dart';
import 'package:gestauto/domaine/depots/depot_authentification.dart';
import 'package:gestauto/domaine/entites/utilisateur.dart';
import 'package:gestauto/presentation/authentification/page_inscription.dart';

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

PageInscription _creerPageInscription() {
  final depot = _DepotAuthentificationFictif();

  return PageInscription(
    inscrireUtilisateur: InscrireUtilisateur(
      depot: depot,
    ),
  );
}

void main() {
  testWidgets(
    'la page d inscription affiche les éléments principaux',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: _creerPageInscription(),
        ),
      );

      expect(
        find.text('Inscription'),
        findsOneWidget,
      );

      expect(
        find.text('Créer un compte'),
        findsOneWidget,
      );

      expect(
        find.text('Rejoignez GESTAUTO'),
        findsOneWidget,
      );

      expect(
        find.text('Nom'),
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
        find.text('Confirmer le mot de passe'),
        findsOneWidget,
      );

      expect(
        find.text("S'inscrire"),
        findsOneWidget,
      );

      expect(
        find.text(
          'Déjà un compte ? Se connecter',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'la validation affiche les erreurs si les champs sont vides',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: _creerPageInscription(),
        ),
      );

      await tester.tap(
        find.text("S'inscrire"),
      );

      await tester.pump();

      expect(
        find.text('Veuillez saisir votre nom'),
        findsOneWidget,
      );

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

      expect(
        find.text(
          'Veuillez confirmer votre mot de passe',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'la validation refuse un mot de passe trop court',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: _creerPageInscription(),
        ),
      );

      final champsTexte =
          find.byType(TextFormField);

      await tester.enterText(
        champsTexte.at(0),
        'Freju Seka',
      );

      await tester.enterText(
        champsTexte.at(1),
        'freju@test.com',
      );

      await tester.enterText(
        champsTexte.at(2),
        '1234567',
      );

      await tester.enterText(
        champsTexte.at(3),
        '1234567',
      );

      await tester.tap(
        find.text("S'inscrire"),
      );

      await tester.pump();

      expect(
        find.text(
          'Le mot de passe doit contenir au moins 8 caractères',
        ),
        findsOneWidget,
      );
    },
  );
}
