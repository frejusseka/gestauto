import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/entites/versement.dart';

void main() {
  test('un versement conforme doit être correctement calculé', () {
    final versement = Versement(
      id: '1',
      vehiculeId: 'vehicule-1',
      date: DateTime(2026, 9, 16),
      montantAttendu: 20000,
      montantVerse: 20000,
    );

    expect(versement.id, '1');
    expect(versement.vehiculeId, 'vehicule-1');
    expect(versement.montantAttendu, 20000);
    expect(versement.montantVerse, 20000);
    expect(versement.ecart, 0);
    expect(versement.statut, StatutVersement.conforme);
  });

  test('un versement inférieur au montant attendu doit être une infraction', () {
    final versement = Versement(
      id: '2',
      vehiculeId: 'vehicule-1',
      date: DateTime(2026, 9, 16),
      montantAttendu: 20000,
      montantVerse: 15000,
    );

    expect(versement.ecart, 5000);
    expect(versement.statut, StatutVersement.infraction);
  });

  test('un versement supérieur au montant attendu doit être conforme', () {
    final versement = Versement(
      id: '3',
      vehiculeId: 'vehicule-1',
      date: DateTime(2026, 9, 16),
      montantAttendu: 20000,
      montantVerse: 22000,
    );

    expect(versement.ecart, -2000);
    expect(versement.statut, StatutVersement.conforme);
  });
}