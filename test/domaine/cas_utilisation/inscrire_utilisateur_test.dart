import 'package:flutter_test/flutter_test.dart';

import 'package:gestauto/domaine/cas_utilisation/inscrire_utilisateur.dart';
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
  late InscrireUtilisateur inscrireUtilisateur;

  setUp(() {
    inscrireUtilisateur = InscrireUtilisateur(
      depot: FauxDepotAuthentification(),
    );
  });

  test(
    'inscrire retourne le nouvel utilisateur',
    () async {
      final utilisateur =
          await inscrireUtilisateur.executer(
        nom: 'Freju',
        email: 'freju@gestauto.com',
        motDePasse: 'mot-de-passe',
      );

      expect(
        utilisateur.id,
        'utilisateur-test',
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
}