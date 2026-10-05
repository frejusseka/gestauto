import 'package:dart_frog/dart_frog.dart';

import 'package:gestauto_backend/coeur/base_de_donnees/connexion_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_depense_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_document_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_entretien_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_panne_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_type_document_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_vehicule_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_versement_postgresql.dart';
import 'package:gestauto_backend/donnees/services/service_alertes_impl.dart';

final _connexionPostgresql = ConnexionPostgresql();

final _depotVehicule = DepotVehiculePostgresql(
  connexionPostgresql: _connexionPostgresql,
);

final _depotVersement = DepotVersementPostgresql(
  connexionPostgresql: _connexionPostgresql,
);

final _depotDepense = DepotDepensePostgresql(
  connexionPostgresql: _connexionPostgresql,
);

final _depotPanne = DepotPannePostgresql(
  connexionPostgresql: _connexionPostgresql,
);

final _depotEntretien = DepotEntretienPostgresql(
  connexionPostgresql: _connexionPostgresql,
);

final _depotDocument = DepotDocumentPostgresql(
  connexionPostgresql: _connexionPostgresql,
);

final _depotTypeDocument = DepotTypeDocumentPostgresql(
  connexionPostgresql: _connexionPostgresql,
);

final _serviceAlertes = ServiceAlertesImpl();

bool _connexionOuverte = false;

Future<void> _ouvrirConnexion() async {
  if (_connexionOuverte) {
    return;
  }

  await _connexionPostgresql.ouvrir();
  _connexionOuverte = true;
}

Handler middleware(Handler handler) {
  return (context) async {
    await _ouvrirConnexion();

    return handler(
      context
          .provide<DepotVehiculePostgresql>(
            () => _depotVehicule,
          )
          .provide<DepotVersementPostgresql>(
            () => _depotVersement,
          )
          .provide<DepotDepensePostgresql>(
            () => _depotDepense,
          )
          .provide<DepotPannePostgresql>(
            () => _depotPanne,
          )
          .provide<DepotEntretienPostgresql>(
            () => _depotEntretien,
          )
          .provide<DepotDocumentPostgresql>(
            () => _depotDocument,
          )
          .provide<DepotTypeDocumentPostgresql>(
            () => _depotTypeDocument,
          )
          .provide<ServiceAlertesImpl>(
            () => _serviceAlertes,
          ),
    );
  };
}