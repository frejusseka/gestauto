abstract class ServiceMotDePasse {
  String hacher(String motDePasse);

  bool verifier({
    required String motDePasse,
    required String motDePasseHache,
  });
}