import 'utilisateur.dart';

class ResultatConnexion {
  final Utilisateur utilisateur;
  final String jeton;

  ResultatConnexion({
    required this.utilisateur,
    required this.jeton,
  });
}