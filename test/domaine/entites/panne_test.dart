import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/entites/panne.dart';

void main() {
  test('une panne ouverte doit être correctement créée', () {
    final panne = Panne(
      id: '1',
      vehiculeId: 'vehicule-1',
      description: 'Câble d\'embrayage cassé',
      date: DateTime(2026, 9, 16),
      kilometrage: 85000,
      statut: StatutPanne.ouverte,
      notes: 'Véhicule immobilisé',
    );

    expect(panne.id, '1');
    expect(panne.vehiculeId, 'vehicule-1');
    expect(panne.description, 'Câble d\'embrayage cassé');
    expect(panne.date, DateTime(2026, 9, 16));
    expect(panne.kilometrage, 85000);
    expect(panne.statut, StatutPanne.ouverte);
    expect(panne.notes, 'Véhicule immobilisé');
  });

  test('une panne peut être résolue', () {
    final panne = Panne(
      id: '2',
      vehiculeId: 'vehicule-1',
      description: 'Pneu crevé',
      date: DateTime(2026, 9, 15),
      kilometrage: 84500,
      statut: StatutPanne.resolue,
    );

    expect(panne.statut, StatutPanne.resolue);
  });

  test('une panne peut être créée sans notes', () {
    final panne = Panne(
      id: '3',
      vehiculeId: 'vehicule-2',
      description: 'Problème de démarrage',
      date: DateTime(2026, 9, 14),
      kilometrage: 72000,
      statut: StatutPanne.ouverte,
    );

    expect(panne.notes, isNull);
  });
}