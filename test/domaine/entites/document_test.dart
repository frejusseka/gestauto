import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/domaine/entites/document.dart';

void main() {
  test('un document avec une date d expiration doit être correctement créé', () {
    final document = Document(
      id: '1',
      vehiculeId: 'vehicule-1',
      type: 'Assurance',
      numero: 'ASS-123456',
      dateEmission: DateTime(2026, 1, 1),
      dateExpiration: DateTime(2026, 12, 31),
      justificatif: 'assurance.jpg',
    );

    expect(document.id, '1');
    expect(document.vehiculeId, 'vehicule-1');
    expect(document.type, 'Assurance');
    expect(document.numero, 'ASS-123456');
    expect(document.dateEmission, DateTime(2026, 1, 1));
    expect(document.dateExpiration, DateTime(2026, 12, 31));
    expect(document.justificatif, 'assurance.jpg');
  });

  test('un document peut ne pas avoir de date d expiration', () {
    final document = Document(
      id: '2',
      vehiculeId: 'vehicule-1',
      type: 'Carte grise',
      numero: 'CG-789012',
      dateEmission: DateTime(2025, 3, 10),
    );

    expect(document.dateExpiration, isNull);
    expect(document.justificatif, isNull);
  });

  test('le type de document doit pouvoir être extensible', () {
    final document = Document(
      id: '3',
      vehiculeId: 'vehicule-1',
      type: 'Visite technique',
      numero: 'VT-456789',
      dateEmission: DateTime(2026, 6, 15),
    );

    expect(document.type, 'Visite technique');
  });
}