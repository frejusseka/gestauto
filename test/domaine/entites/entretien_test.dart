import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/entites/entretien.dart';

void main() {
  test('un entretien doit être correctement créé avec ses prochaines échéances', () {
    final entretien = Entretien(
      id: '1',
      vehiculeId: 'vehicule-1',
      type: 'Vidange',
      date: DateTime(2026, 9, 16),
      kilometrage: 85000,
      montant: 25000,
      prochainKilometrage: 90000,
      prochaineDate: DateTime(2027, 3, 16),
      notes: 'Remplacement de l huile moteur et du filtre.',
    );

    expect(entretien.id, '1');
    expect(entretien.vehiculeId, 'vehicule-1');
    expect(entretien.type, 'Vidange');
    expect(entretien.date, DateTime(2026, 9, 16));
    expect(entretien.kilometrage, 85000);
    expect(entretien.montant, 25000);
    expect(entretien.prochainKilometrage, 90000);
    expect(entretien.prochaineDate, DateTime(2027, 3, 16));
    expect(
      entretien.notes,
      'Remplacement de l huile moteur et du filtre.',
    );
  });

  test('un entretien peut avoir uniquement une prochaine échéance kilométrique', () {
    final entretien = Entretien(
      id: '2',
      vehiculeId: 'vehicule-1',
      type: 'Freinage',
      date: DateTime(2026, 8, 10),
      kilometrage: 80000,
      montant: 45000,
      prochainKilometrage: 95000,
    );

    expect(entretien.prochainKilometrage, 95000);
    expect(entretien.prochaineDate, isNull);
  });

  test('un entretien peut être créé sans prochaine échéance ni notes', () {
    final entretien = Entretien(
      id: '3',
      vehiculeId: 'vehicule-2',
      type: 'Réparation préventive',
      date: DateTime(2026, 7, 5),
      kilometrage: 70000,
      montant: 30000,
    );

    expect(entretien.prochainKilometrage, isNull);
    expect(entretien.prochaineDate, isNull);
    expect(entretien.notes, isNull);
  });
}