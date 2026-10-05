import 'package:bcrypt/bcrypt.dart';

import '../../domaine/services/service_mot_de_passe.dart';

class ServiceMotDePasseBcrypt implements ServiceMotDePasse {
  @override
  String hacher(String motDePasse) {
    return BCrypt.hashpw(
      motDePasse,
      BCrypt.gensalt(),
    );
  }

  @override
  bool verifier({
    required String motDePasse,
    required String motDePasseHache,
  }) {
    return BCrypt.checkpw(
      motDePasse,
      motDePasseHache,
    );
  }
}