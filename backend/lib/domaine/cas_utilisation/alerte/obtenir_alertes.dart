import '../../entites/alerte.dart';
import '../../depots/depot_document.dart';
import '../../depots/depot_entretien.dart';
import '../../depots/depot_type_document.dart';
import '../../depots/depot_vehicule.dart';
import '../../services/service_alertes.dart';

class ObtenirAlertes {
  final DepotVehicule _depotVehicule;
  final DepotDocument _depotDocument;
  final DepotTypeDocument _depotTypeDocument;
  final DepotEntretien _depotEntretien;
  final ServiceAlertes _serviceAlertes;

  ObtenirAlertes({
    required DepotVehicule depotVehicule,
    required DepotDocument depotDocument,
    required DepotTypeDocument depotTypeDocument,
    required DepotEntretien depotEntretien,
    required ServiceAlertes serviceAlertes,
  })  : _depotVehicule = depotVehicule,
        _depotDocument = depotDocument,
        _depotTypeDocument = depotTypeDocument,
        _depotEntretien = depotEntretien,
        _serviceAlertes = serviceAlertes;

  Future<List<Alerte>> executer({
    required String utilisateurId,
    required DateTime dateActuelle,
  }) async {
    final vehicules =
        await _depotVehicule.obtenirTous(utilisateurId);

    final documents = await _depotDocument.obtenirTous(
      utilisateurId: utilisateurId,
    );

    final typesDocuments =
        await _depotTypeDocument.obtenirTous(
      utilisateurId: utilisateurId,
    );

    final entretiens = await _depotEntretien.obtenirTous(
      utilisateurId: utilisateurId,
    );

    return _serviceAlertes.genererAlertes(
      vehicules: vehicules,
      documents: documents,
      typesDocuments: typesDocuments,
      entretiens: entretiens,
      dateActuelle: dateActuelle,
    );
  }
}