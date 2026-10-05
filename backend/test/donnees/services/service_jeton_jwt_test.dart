import 'package:test/test.dart';

import 'package:gestauto_backend/donnees/services/service_jeton_jwt.dart';

void main() {
  group('ServiceJetonJwt', () {
    test('crée puis vérifie un jeton JWT', () {
      final service = ServiceJetonJwt(
        secret: 'secret-test-gestauto',
      );

      final jeton = service.creerJeton(
        utilisateurId: '123',
        email: 'test@example.com',
      );

      final donnees = service.verifierJeton(jeton);

      expect(donnees['utilisateurId'], '123');
      expect(donnees['email'], 'test@example.com');
    });
  });
}