import 'package:dart_frog/dart_frog.dart';

import 'package:gestauto_backend/domaine/cas_utilisation/alerte/obtenir_alertes.dart';
import 'package:gestauto_backend/domaine/entites/alerte.dart';
import 'package:gestauto_backend/donnees/depots/depot_document_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_entretien_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_type_document_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_vehicule_postgresql.dart';
import 'package:gestauto_backend/donnees/services/service_alertes_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: 405,
      body: {
        'message': 'Méthode HTTP non autorisée.',
      },
    );
  }

  final donneesUtilisateur =
      context.read<Map<String, dynamic>>();

  final utilisateurId =
      donneesUtilisateur['utilisateurId'] as String?;

  if (utilisateurId == null || utilisateurId.isEmpty) {
    return Response.json(
      statusCode: 401,
      body: {
        'message': 'Utilisateur non authentifié.',
      },
    );
  }

  final obtenirAlertes = ObtenirAlertes(
    depotVehicule:
        context.read<DepotVehiculePostgresql>(),
    depotDocument:
        context.read<DepotDocumentPostgresql>(),
    depotTypeDocument:
        context.read<DepotTypeDocumentPostgresql>(),
    depotEntretien:
        context.read<DepotEntretienPostgresql>(),
    serviceAlertes:
        context.read<ServiceAlertesImpl>(),
  );

  try {
    final alertes = await obtenirAlertes.executer(
      utilisateurId: utilisateurId,
      dateActuelle: DateTime.now(),
    );

    return Response.json(
      statusCode: 200,
      body: {
        'alertes': alertes.map(_convertirAlerte).toList(),
      },
    );
  } catch (erreur) {
    return Response.json(
      statusCode: 500,
      body: {
        'message': 'Impossible de récupérer les alertes.',
      },
    );
  }
}

Map<String, dynamic> _convertirAlerte(Alerte alerte) {
  return {
    'type': alerte.type.name,
    'vehiculeId': alerte.vehiculeId,
    'titre': alerte.titre,
    'message': alerte.message,
    'niveau': alerte.niveau.name,
  };
}