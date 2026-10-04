import '../../domaine/entites/tableau_de_bord.dart';

class TableauDeBordModele {
  final PeriodeModele periode;
  final int nombreVehicules;
  final double montantVersementsAttendus;
  final double montantVersementsRecus;
  final double ecartVersements;
  final double montantDepenses;
  final double resultatEstime;
  final int nombrePannes;
  final int nombreEntretiensAVenir;
  final int nombreAlertes;
  final List<PerformanceVehiculeModele> performancesVehicules;

  TableauDeBordModele({
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

  factory TableauDeBordModele.fromJson(
    Map<String, dynamic> json,
  ) {
    final donneesPeriode =
        json['periode'] as Map<String, dynamic>;

    final donneesPerformances =
        json['performancesVehicules'] as List<dynamic>;

    return TableauDeBordModele(
      periode: PeriodeModele.fromJson(
        donneesPeriode,
      ),
      nombreVehicules:
          (json['nombreVehicules'] as num).toInt(),
      montantVersementsAttendus:
          (json['montantVersementsAttendus'] as num).toDouble(),
      montantVersementsRecus:
          (json['montantVersementsRecus'] as num).toDouble(),
      ecartVersements:
          (json['ecartVersements'] as num).toDouble(),
      montantDepenses:
          (json['montantDepenses'] as num).toDouble(),
      resultatEstime:
          (json['resultatEstime'] as num).toDouble(),
      nombrePannes:
          (json['nombrePannes'] as num).toInt(),
      nombreEntretiensAVenir:
          (json['nombreEntretiensAVenir'] as num).toInt(),
      nombreAlertes:
          (json['nombreAlertes'] as num).toInt(),
      performancesVehicules:
          donneesPerformances
              .map(
                (element) =>
                    PerformanceVehiculeModele.fromJson(
                  element as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  TableauDeBord toEntite() {
    return TableauDeBord(
      periode: periode.toEntite(),
      nombreVehicules: nombreVehicules,
      montantVersementsAttendus:
          montantVersementsAttendus,
      montantVersementsRecus:
          montantVersementsRecus,
      ecartVersements: ecartVersements,
      montantDepenses: montantDepenses,
      resultatEstime: resultatEstime,
      nombrePannes: nombrePannes,
      nombreEntretiensAVenir:
          nombreEntretiensAVenir,
      nombreAlertes: nombreAlertes,
      performancesVehicules:
          performancesVehicules
              .map(
                (performance) =>
                    performance.toEntite(),
              )
              .toList(),
    );
  }
}

class PeriodeModele {
  final DateTime debut;
  final DateTime fin;

  PeriodeModele({
    required this.debut,
    required this.fin,
  });

  factory PeriodeModele.fromJson(
    Map<String, dynamic> json,
  ) {
    return PeriodeModele(
      debut: DateTime.parse(
        json['debut'] as String,
      ),
      fin: DateTime.parse(
        json['fin'] as String,
      ),
    );
  }

  Periode toEntite() {
    return Periode(
      debut: debut,
      fin: fin,
    );
  }
}

class PerformanceVehiculeModele {
  final String vehiculeId;
  final double montantVersementsAttendus;
  final double montantVersementsRecus;
  final double ecartVersements;
  final double montantDepenses;
  final double resultatEstime;

  PerformanceVehiculeModele({
    required this.vehiculeId,
    required this.montantVersementsAttendus,
    required this.montantVersementsRecus,
    required this.ecartVersements,
    required this.montantDepenses,
    required this.resultatEstime,
  });

  factory PerformanceVehiculeModele.fromJson(
    Map<String, dynamic> json,
  ) {
    return PerformanceVehiculeModele(
      vehiculeId: json['vehiculeId'] as String,
      montantVersementsAttendus:
          (json['montantVersementsAttendus'] as num)
              .toDouble(),
      montantVersementsRecus:
          (json['montantVersementsRecus'] as num)
              .toDouble(),
      ecartVersements:
          (json['ecartVersements'] as num).toDouble(),
      montantDepenses:
          (json['montantDepenses'] as num).toDouble(),
      resultatEstime:
          (json['resultatEstime'] as num).toDouble(),
    );
  }

  PerformanceVehicule toEntite() {
    return PerformanceVehicule(
      vehiculeId: vehiculeId,
      montantVersementsAttendus:
          montantVersementsAttendus,
      montantVersementsRecus:
          montantVersementsRecus,
      ecartVersements: ecartVersements,
      montantDepenses: montantDepenses,
      resultatEstime: resultatEstime,
    );
  }
}