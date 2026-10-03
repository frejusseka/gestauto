import '../entites/utilisateur.dart';

abstract class DepotAuthentification {
  Future<ResultatAuthentification> connecter({
    required String email,
    required String motDePasse,
  });

  Future<Utilisateur> inscrire({
    required String nom,
    required String email,
    required String motDePasse,
  });

  Future<void> deconnecter();
}

class ResultatAuthentification {
  final Utilisateur utilisateur;
  final String jeton;

  ResultatAuthentification({
    required this.utilisateur,
    required this.jeton,
  });
}