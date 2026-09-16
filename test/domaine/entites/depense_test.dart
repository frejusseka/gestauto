import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/entites/depense.dart';

void main() {
  test('une dépense doit être correctement créée avec un justificatif', () {
    final depense = Depense(
      id: '1',
      vehiculeId: 'vehicule-1',
      categorie: 'Réparation',
      description: 'Remplacement du câble d\'embrayage',
      montant: 35000,
      date: DateTime(2026, 9, 16),
      justificatif: 'facture-embrayage.jpg',
    );

    expect(depense.id, '1');
    expect(depense.vehiculeId, 'vehicule-1');
    expect(depense.categorie, 'Réparation');
    expect(
      depense.description,
      'Remplacement du câble d\'embrayage',
    );
    expect(depense.montant, 35000);
    expect(depense.date, DateTime(2026, 9, 16));
    expect(depense.justificatif, 'facture-embrayage.jpg');
  });

  test('une dépense peut être créée sans justificatif', () {
    final depense = Depense(
      id: '2',
      vehiculeId: 'vehicule-2',
      categorie: 'Lavage',
      description: 'Lavage complet du véhicule',
      montant: 5000,
      date: DateTime(2026, 9, 15),
    );

    expect(depense.justificatif, isNull);
  });

  test('la catégorie d une dépense doit pouvoir être extensible', () {
    final depense = Depense(
      id: '3',
      vehiculeId: 'vehicule-1',
      categorie: 'Pièce électronique',
      description: 'Remplacement du relais électrique',
      montant: 12000,
      date: DateTime(2026, 9, 14),
    );

    expect(depense.categorie, 'Pièce électronique');
  });
}