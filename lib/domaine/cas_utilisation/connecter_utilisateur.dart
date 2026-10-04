import '../depots/depot_authentification.dart';
import '../../coeur/stockage/stockage_session.dart';

class ConnecterUtilisateur {
  final DepotAuthentification _depot;
  final StockageSession _stockageSession;

  ConnecterUtilisateur({
    required this._depot,
    required this._stockageSession,
  });

  Future<ResultatAuthentification> executer({
    required String email,
    required String motDePasse,
  }) async {
    final resultat = await _depot.connecter(
      email: email,
      motDePasse: motDePasse,
    );

    await _stockageSession.enregistrerJeton(
      resultat.jeton,
    );

    return resultat;
  }
}