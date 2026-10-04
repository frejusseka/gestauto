import 'package:flutter_test/flutter_test.dart';

import 'package:gestauto/donnees/modeles/tableau_de_bord_modele.dart';

void main() {
  test(
    'doit convertir correctement le JSON du tableau de bord',
    () {
      final json = {
        'periode': {
          'debut': '2026-10-01',
          'fin': '2026-10-31',
        },
        'nombreVehicules': 1,
        'montantVersementsAttendus': 60000,
        'montantVersementsRecus': 55000,
        'ecartVersements': 5000,
        'montantDepenses': 10000,
        'resultatEstime': 45000,
        'nombrePannes': 0,
        'nombreEntretiensAVenir': 0,
        'nombreAlertes': 0,
        'performancesVehicules': [
          {
            'vehiculeId':
                '70000000-0000-0000-0000-000000000001',
            'marque': 'Toyota',
            'modele': 'Corolla',
            'immatriculation': 'TEST-GA-001',
            'versementsAttendus': 60000,
            'versementsRecus': 55000,
            'ecartVersements': 5000,
            'depenses': 10000,
            'resultatEstime': 45000,
          },
        ],
      };

      final modele =
          TableauDeBordModele.fromJson(json);

      final tableauDeBord = modele.toEntite();

      expect(tableauDeBord.nombreVehicules, 1);
      expect(
        tableauDeBord.montantVersementsAttendus,
        60000,
      );
      expect(
        tableauDeBord.montantVersementsRecus,
        55000,
      );
      expect(
        tableauDeBord.ecartVersements,
        5000,
      );
      expect(
        tableauDeBord.montantDepenses,
        10000,
      );
      expect(
        tableauDeBord.resultatEstime,
        45000,
      );

      expect(
        tableauDeBord.performancesVehicules.length,
        1,
      );

      final performance =
          tableauDeBord.performancesVehicules.first;

      expect(
        performance.vehiculeId,
        '70000000-0000-0000-0000-000000000001',
      );
      expect(
        performance.montantVersementsAttendus,
        60000,
      );
      expect(
        performance.montantVersementsRecus,
        55000,
      );
      expect(
        performance.ecartVersements,
        5000,
      );
      expect(
        performance.montantDepenses,
        10000,
      );
      expect(
        performance.resultatEstime,
        45000,
      );
    },
  );
}