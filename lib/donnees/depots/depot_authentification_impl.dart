import '../../domaine/depots/depot_authentification.dart';
import '../../domaine/entites/utilisateur.dart';
import '../sources/distantes/source_authentification_distante_api.dart';

class DepotAuthentificationImpl
    implements DepotAuthentification {
  final SourceAuthentificationDistanteApi _sourceDistante;

  DepotAuthentificationImpl({
    required this._sourceDistante,
  });

  @override
  Future<ResultatAuthentification> connecter({
    required String email,
    required String motDePasse,
  }) {
    return _sourceDistante.connecter(
      email: email,
      motDePasse: motDePasse,
    );
  }

  @override
  Future<Utilisateur> inscrire({
    required String nom,
    required String email,
    required String motDePasse,
  }) {
    return _sourceDistante.inscrire(
      nom: nom,
      email: email,
      motDePasse: motDePasse,
    );
  }

  @override
  Future<void> deconnecter() {
    return _sourceDistante.deconnecter();
  }
}