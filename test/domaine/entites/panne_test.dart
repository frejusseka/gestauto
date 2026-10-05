import 'package:flutter_test/flutter_test.dart';

import 'package:gestauto/domaine/entites/panne.dart';

void main() {
  group('Panne', () {
    test('crée une panne non résolue', () {
      final date = DateTime(2026, 10, 5);

      final panne = Panne(
        id: '1',
        vehiculeId: 'vehicule-1',
        date: date,
        description: 'Problème de freinage',
        gravite: GravitePanne.grave,
        resolue: false,
      );

      expect(panne.id, '1');
      expect(panne.vehiculeId, 'vehicule-1');
      expect(panne.date, date);
      expect(
        panne.description,
        'Problème de freinage',
      );
      expect(
        panne.gravite,
        GravitePanne.grave,
      );
      expect(panne.resolue, false);
      expect(panne.dateResolution, isNull);
    });

    test('crée une panne résolue avec une date de résolution', () {
      final date = DateTime(2026, 10, 1);
      final dateResolution = DateTime(2026, 10, 4);

      final panne = Panne(
        id: '2',
        vehiculeId: 'vehicule-2',
        date: date,
        description: 'Pneu crevé',
        gravite: GravitePanne.moyenne,
        resolue: true,
        dateResolution: dateResolution,
      );

      expect(panne.gravite, GravitePanne.moyenne);
      expect(panne.resolue, true);
      expect(
        panne.dateResolution,
        dateResolution,
      );
    });

    test('une panne peut avoir une gravité faible', () {
      final panne = Panne(
        id: '3',
        vehiculeId: 'vehicule-3',
        date: DateTime(2026, 10, 5),
        description: 'Petit problème',
        gravite: GravitePanne.faible,
        resolue: false,
      );

      expect(
        panne.gravite,
        GravitePanne.faible,
      );
      expect(panne.resolue, false);
    });
  });
}