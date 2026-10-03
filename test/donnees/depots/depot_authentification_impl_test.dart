import 'package:test/test.dart';

import 'package:gestauto/domaine/depots/depot_authentification.dart';
import 'package:gestauto/domaine/entites/utilisateur.dart';
import 'package:gestauto/donnees/depots/depot_authentification_impl.dart';
import 'package:gestauto/donnees/sources/distantes/source_authentification_distante_api.dart';

class FausseSourceAuthentificationDistante
    implements SourceAuthentificationDistanteApi {
  @override
  Future<ResultatAuthentification> connecter({
    required String email,
    required String motDePasse,
  }) async {
    return ResultatAuthentification(
      utilisateur: Utilisateur(
        id: 'utilisateur-test',
        nom: 'Utilisateur Test',
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
  late DepotAuthentificationImpl depot;

  setUp(() {
    depot = DepotAuthentificationImpl(
      sourceDistante:
          FausseSourceAuthentificationDistante(),
    );
  });

  test(
    'connecter retourne l utilisateur et le jeton',
    () async {
      final resultat = await depot.connecter(
        email: 'test@gestauto.com',
        motDePasse: 'mot-de-passe',
      );

      expect(
        resultat.utilisateur.email,
        'test@gestauto.com',
      );

      expect(
        resultat.jeton,
        'jeton-test',
      );
    },
  );

  test(
    'inscrire retourne le nouvel utilisateur',
    () async {
      final utilisateur = await depot.inscrire(
        nom: 'Freju',
        email: 'freju@gestauto.com',
        motDePasse: 'mot-de-passe',
      );

      expect(
        utilisateur.nom,
        'Freju',
      );

      expect(
        utilisateur.email,
        'freju@gestauto.com',
      );
    },
  );

  test(
    'deconnecter peut être appelé',
    () async {
      await depot.deconnecter();

      expect(true, isTrue);
    },
  );
}