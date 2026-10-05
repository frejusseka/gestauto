import '../../coeur/erreurs/identifiants_invalides_exception.dart';
import '../depots/depot_utilisateur.dart';
import '../entites/resultat_connexion.dart';
import '../services/service_jeton.dart';
import '../services/service_mot_de_passe.dart';

class ConnecterUtilisateur {
  final DepotUtilisateur _depot;
  final ServiceMotDePasse _serviceMotDePasse;
  final ServiceJeton _serviceJeton;

  ConnecterUtilisateur({
    required DepotUtilisateur depot,
    required ServiceMotDePasse serviceMotDePasse,
    required ServiceJeton serviceJeton,
  })  : _depot = depot,
        _serviceMotDePasse = serviceMotDePasse,
        _serviceJeton = serviceJeton;

  Future<ResultatConnexion> executer({
    required String email,
    required String motDePasse,
  }) async {
    final utilisateur = await _depot.obtenirParEmail(email);

    if (utilisateur == null) {
      throw IdentifiantsInvalidesException();
    }

    final motDePasseCorrect = _serviceMotDePasse.verifier(
      motDePasse: motDePasse,
      motDePasseHache: utilisateur.motDePasse,
    );

    if (!motDePasseCorrect) {
      throw IdentifiantsInvalidesException();
    }

    final jeton = _serviceJeton.creerJeton(
      utilisateurId: utilisateur.id,
      email: utilisateur.email,
    );

    return ResultatConnexion(
      utilisateur: utilisateur,
      jeton: jeton,
    );
  }
}