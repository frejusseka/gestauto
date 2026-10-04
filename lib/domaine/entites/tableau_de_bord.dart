class TableauDeBord {
  final Periode periode;
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
    required this.periode,
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

class Periode {
  final DateTime debut;
  final DateTime fin;

  Periode({
    required this.debut,
    required this.fin,
  });
}

class PerformanceVehicule {
  final String vehiculeId;
  final double montantVersementsAttendus;
  final double montantVersementsRecus;
  final double ecartVersements;
  final double montantDepenses;
  final double resultatEstime;

  PerformanceVehicule({
    required this.vehiculeId,
    required this.montantVersementsAttendus,
    required this.montantVersementsRecus,
    required this.ecartVersements,
    required this.montantDepenses,
    required this.resultatEstime,
  });
}