import '../depots/depot_authentification.dart';

class ConnecterUtilisateur {
  final DepotAuthentification _depot;

  ConnecterUtilisateur({
    required this._depot,
  });

  Future<ResultatAuthentification> executer({
    required String email,
    required String motDePasse,
  }) {
    return _depot.connecter(
      email: email,
      motDePasse: motDePasse,
    );
  }
}