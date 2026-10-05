import 'package:flutter_test/flutter_test.dart';

import 'package:gestauto/domaine/entites/depense.dart';

void main() {
  group('Depense', () {
    test(
      'doit créer une dépense avec ses informations',
      () {
        final date = DateTime(2026, 10, 4);

        final depense = Depense(
          id: 'depense-1',
          vehiculeId: 'vehicule-1',
          categorieId: 'categorie-1',
          date: date,
          montant: 15000,
          description: 'Changement de plaquettes',
        );

        expect(depense.id, 'depense-1');
        expect(
          depense.vehiculeId,
          'vehicule-1',
        );
        expect(
          depense.categorieId,
          'categorie-1',
        );
        expect(depense.date, date);
        expect(depense.montant, 15000);
        expect(
          depense.description,
          'Changement de plaquettes',
        );
      },
    );

    test(
      'doit accepter une description nulle',
      () {
        final depense = Depense(
          id: 'depense-2',
          vehiculeId: 'vehicule-2',
          categorieId: 'categorie-2',
          date: DateTime(2026, 10, 4),
          montant: 5000,
        );

        expect(depense.description, isNull);
      },
    );

    test(
      'doit conserver le montant décimal',
      () {
        final depense = Depense(
          id: 'depense-3',
          vehiculeId: 'vehicule-3',
          categorieId: 'categorie-3',
          date: DateTime(2026, 10, 4),
          montant: 12500.50,
        );

        expect(depense.montant, 12500.50);
      },
    );
  });
}