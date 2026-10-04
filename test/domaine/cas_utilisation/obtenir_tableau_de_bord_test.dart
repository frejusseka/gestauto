import 'package:flutter_test/flutter_test.dart';

import 'package:gestauto/domaine/cas_utilisation/obtenir_tableau_de_bord.dart';
import 'package:gestauto/domaine/depots/depot_tableau_de_bord.dart';
import 'package:gestauto/domaine/entites/tableau_de_bord.dart';

class FauxDepotTableauDeBord
    implements DepotTableauDeBord {
  @override
  Future<TableauDeBord> obtenir() async {
    return TableauDeBord(
      periode: Periode(
        debut: DateTime(2026, 10, 1),
        fin: DateTime(2026, 10, 31),
      ),
      nombreVehicules: 5,
      montantVersementsAttendus: 500000,
      montantVersementsRecus: 450000,
      ecartVersements: 50000,
      montantDepenses: 150000,
      resultatEstime: 300000,
      nombrePannes: 2,
      nombreEntretiensAVenir: 1,
      nombreAlertes: 3,
      performancesVehicules: [],
    );
  }
}

void main() {
  test(
    'doit obtenir le tableau de bord depuis le dépôt',
    () async {
      final depot = FauxDepotTableauDeBord();

      final casUtilisation = ObtenirTableauDeBord(
        depot: depot,
      );

      final tableauDeBord =
          await casUtilisation.executer();

      expect(tableauDeBord.nombreVehicules, 5);
      expect(
        tableauDeBord.montantVersementsAttendus,
        500000,
      );
      expect(
        tableauDeBord.montantVersementsRecus,
        450000,
      );
      expect(
        tableauDeBord.ecartVersements,
        50000,
      );
      expect(
        tableauDeBord.montantDepenses,
        150000,
      );
      expect(
        tableauDeBord.resultatEstime,
        300000,
      );
      expect(tableauDeBord.nombrePannes, 2);
      expect(
        tableauDeBord.nombreEntretiensAVenir,
        1,
      );
      expect(tableauDeBord.nombreAlertes, 3);
    },
  );
}