import '../../depots/depot_depense.dart';
import '../../depots/depot_document.dart';
import '../../depots/depot_entretien.dart';
import '../../depots/depot_panne.dart';
import '../../depots/depot_type_document.dart';
import '../../depots/depot_vehicule.dart';
import '../../depots/depot_versement.dart';
import '../../entites/tableau_de_bord.dart';
import '../../services/service_alertes.dart';

class ObtenirTableauDeBord {
  final DepotVehicule _depotVehicule;
  final DepotVersement _depotVersement;
  final DepotDepense _depotDepense;
  final DepotPanne _depotPanne;
  final DepotEntretien _depotEntretien;
  final DepotDocument _depotDocument;
  final DepotTypeDocument _depotTypeDocument;
  final ServiceAlertes _serviceAlertes;

  ObtenirTableauDeBord({
    required DepotVehicule depotVehicule,
    required DepotVersement depotVersement,
    required DepotDepense depotDepense,
    required DepotPanne depotPanne,
    required DepotEntretien depotEntretien,
    required DepotDocument depotDocument,
    required DepotTypeDocument depotTypeDocument,
    required ServiceAlertes serviceAlertes,
  })  : _depotVehicule = depotVehicule,
        _depotVersement = depotVersement,
        _depotDepense = depotDepense,
        _depotPanne = depotPanne,
        _depotEntretien = depotEntretien,
        _depotDocument = depotDocument,
        _depotTypeDocument = depotTypeDocument,
        _serviceAlertes = serviceAlertes;

  Future<TableauDeBord> executer({
    required String utilisateurId,
    required DateTime debutPeriode,
    required DateTime finPeriode,
  }) async {
    final vehicules =
        await _depotVehicule.obtenirTous(utilisateurId);

    final versements = await _depotVersement.obtenirTous(
      utilisateurId: utilisateurId,
    );

    final depenses = await _depotDepense.obtenirTous(
      utilisateurId: utilisateurId,
    );

    final pannes = await _depotPanne.obtenirTous(
      utilisateurId: utilisateurId,
    );

    final entretiens = await _depotEntretien.obtenirTous(
      utilisateurId: utilisateurId,
    );

    final documents = await _depotDocument.obtenirTous(
      utilisateurId: utilisateurId,
    );

    final typesDocuments =
        await _depotTypeDocument.obtenirTous(
      utilisateurId: utilisateurId,
    );

    final alertes = _serviceAlertes.genererAlertes(
      vehicules: vehicules,
      documents: documents,
      typesDocuments: typesDocuments,
      entretiens: entretiens,
      dateActuelle: DateTime.now(),
    );

    final versementsPeriode = versements.where((versement) {
      return !versement.date.isBefore(debutPeriode) &&
          !versement.date.isAfter(finPeriode);
    }).toList();

    final depensesPeriode = depenses.where((depense) {
      return !depense.date.isBefore(debutPeriode) &&
          !depense.date.isAfter(finPeriode);
    }).toList();

    final pannesPeriode = pannes.where((panne) {
      return !panne.date.isBefore(debutPeriode) &&
          !panne.date.isAfter(finPeriode);
    }).toList();

    final montantVersementsAttendus =
        versementsPeriode.fold<double>(
      0,
      (total, versement) =>
          total + versement.montantAttendu,
    );

    final montantVersementsRecus =
        versementsPeriode.fold<double>(
      0,
      (total, versement) =>
          total + versement.montantVerse,
    );

    final ecartVersements =
        montantVersementsAttendus - montantVersementsRecus;

    final montantDepenses =
        depensesPeriode.fold<double>(
      0,
      (total, depense) => total + depense.montant,
    );

    final resultatEstime =
        montantVersementsRecus - montantDepenses;

    final maintenant = DateTime.now();

    final dateLimiteEntretiens =
        maintenant.add(
      const Duration(days: 30),
    );

    final entretiensAVenir = entretiens.where((entretien) {
      final prochaineDate = entretien.prochaineDate;

      if (prochaineDate == null) {
        return false;
      }

      return prochaineDate.isAfter(maintenant) &&
          !prochaineDate.isAfter(dateLimiteEntretiens);
    }).toList();

    final performancesVehicules =
        vehicules.map((vehicule) {
      final versementsVehicule =
          versementsPeriode.where(
        (versement) =>
            versement.vehiculeId == vehicule.id,
      );

      final depensesVehicule =
          depensesPeriode.where(
        (depense) =>
            depense.vehiculeId == vehicule.id,
      );

      final versementsAttendus =
          versementsVehicule.fold<double>(
        0,
        (total, versement) =>
            total + versement.montantAttendu,
      );

      final versementsRecus =
          versementsVehicule.fold<double>(
        0,
        (total, versement) =>
            total + versement.montantVerse,
      );

      final ecart =
          versementsAttendus - versementsRecus;

      final depenses =
          depensesVehicule.fold<double>(
        0,
        (total, depense) =>
            total + depense.montant,
      );

      final resultat =
          versementsRecus - depenses;

      return PerformanceVehicule(
        vehicule: vehicule,
        versementsAttendus: versementsAttendus,
        versementsRecus: versementsRecus,
        ecartVersements: ecart,
        depenses: depenses,
        resultatEstime: resultat,
      );
    }).toList();

    return TableauDeBord(
      debutPeriode: debutPeriode,
      finPeriode: finPeriode,
      nombreVehicules: vehicules.length,
      montantVersementsAttendus: montantVersementsAttendus,
      montantVersementsRecus: montantVersementsRecus,
      ecartVersements: ecartVersements,
      montantDepenses: montantDepenses,
      resultatEstime: resultatEstime,
      nombrePannes: pannesPeriode.length,
      nombreEntretiensAVenir: entretiensAVenir.length,
      nombreAlertes: alertes.length,
      performancesVehicules: performancesVehicules,
    );
  }
}