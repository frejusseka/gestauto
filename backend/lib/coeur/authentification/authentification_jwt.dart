import '../../domaine/services/service_jeton.dart';

class AuthentificationJwt {
  final ServiceJeton _serviceJeton;

  AuthentificationJwt({
    required ServiceJeton serviceJeton,
  }) : _serviceJeton = serviceJeton;

  Map<String, dynamic> authentifier(String jeton) {
    return _serviceJeton.verifierJeton(jeton);
  }
}