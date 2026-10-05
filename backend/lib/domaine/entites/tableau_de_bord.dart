import 'vehicule.dart';

class PerformanceVehicule {
  final Vehicule vehicule;
  final double versementsAttendus;
  final double versementsRecus;
  final double ecartVersements;
  final double depenses;
  final double resultatEstime;

  PerformanceVehicule({
    required this.vehicule,
    required this.versementsAttendus,
    required this.versementsRecus,
    required this.ecartVersements,
    required this.depenses,
    required this.resultatEstime,
  });
}

class TableauDeBord {
  final DateTime debutPeriode;
  final DateTime finPeriode;

  final int nombreVehicules;

  final double montantVersementsAttendus;
  final double montantVersementsRecus;
  final double ecartVersements;

  final double montantDepenses;
  final double resultatEstime;

  final int nombrePannes;
  final int nombreEntretiensAVenir;
  final int nombreAlertes;

  final List<PerformanceVehicule> performancesVehicules;

  TableauDeBord({
    required this.debutPeriode,
    required this.finPeriode,
    required this.nombreVehicules,
    required this.montantVersementsAttendus,
    required this.montantVersementsRecus,
    required this.ecartVersements,
    required this.montantDepenses,
    required this.resultatEstime,
    required this.nombrePannes,
    required this.nombreEntretiensAVenir,
    required this.nombreAlertes,
    required this.performancesVehicules,
  });
}