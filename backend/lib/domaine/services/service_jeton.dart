abstract class ServiceJeton {
  String creerJeton({
    required String utilisateurId,
    required String email,
  });

  Map<String, dynamic> verifierJeton(String jeton);
}