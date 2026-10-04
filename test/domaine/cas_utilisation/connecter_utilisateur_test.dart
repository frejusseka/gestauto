import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gestauto/coeur/stockage/stockage_session.dart';
import 'package:gestauto/domaine/cas_utilisation/connecter_utilisateur.dart';
import 'package:gestauto/domaine/depots/depot_authentification.dart';
import 'package:gestauto/domaine/entites/utilisateur.dart';

class FauxDepotAuthentification
    implements DepotAuthentification {
  @override
  Future<ResultatAuthentification> connecter({
    required String email,
    required String motDePasse,
  }) async {
    return ResultatAuthentification(
      utilisateur: Utilisateur(
        id: 'utilisateur-test',
        nom: 'Freju',
        email: email,
      ),
      jeton: 'jeton-test',
    );
  }

  @override
  Future<Utilisateur> inscrire({
    required String nom,
    required String email,
    required String motDePasse,
  }) async {
    return Utilisateur(
      id: 'utilisateur-test',
      nom: nom,
      email: email,
    );
  }

  @override
  Future<void> deconnecter() async {}
}

void main() {
  late StockageSession stockageSession;
  late ConnecterUtilisateur connecterUtilisateur;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    stockageSession = StockageSession();

    connecterUtilisateur = ConnecterUtilisateur(
      depot: FauxDepotAuthentification(),
      stockageSession: stockageSession,
    );
  });

  test(
    'connecter enregistre le JWT reçu du dépôt',
    () async {
      final resultat = await connecterUtilisateur.executer(
        email: 'test@gestauto.com',
        motDePasse: 'mot-de-passe',
      );

      final jeton = await stockageSession.obtenirJeton();

      expect(
        resultat.jeton,
        'jeton-test',
      );

      expect(
        jeton,
        'jeton-test',
      );
    },
  );
}