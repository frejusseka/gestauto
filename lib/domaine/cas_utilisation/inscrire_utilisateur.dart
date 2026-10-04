import '../depots/depot_authentification.dart';
import '../entites/utilisateur.dart';

class InscrireUtilisateur {
  final DepotAuthentification _depot;

  InscrireUtilisateur({
    required this._depot,
  });

  Future<Utilisateur> executer({
    required String nom,
    required String email,
    required String motDePasse,
  }) {
    return _depot.inscrire(
      nom: nom,
      email: email,
      motDePasse: motDePasse,
    );
  }
}