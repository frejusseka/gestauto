import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../domaine/services/service_jeton.dart';

class ServiceJetonJwt implements ServiceJeton {
  final String _secret;

  ServiceJetonJwt({
    required String secret,
  }) : _secret = secret;

  @override
  String creerJeton({
    required String utilisateurId,
    required String email,
  }) {
    final jeton = JWT(
      {
        'utilisateurId': utilisateurId,
        'email': email,
      },
    );

    return jeton.sign(
      SecretKey(_secret),
      expiresIn: const Duration(minutes: 15),
    );
  }

  @override
  Map<String, dynamic> verifierJeton(String jeton) {
    final jwt = JWT.verify(
      jeton,
      SecretKey(_secret),
    );

    return Map<String, dynamic>.from(
      jwt.payload as Map,
    );
  }
}