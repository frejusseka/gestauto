import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/coeur/base_de_donnees/connexion_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_vehicule_postgresql.dart';

final _connexionPostgresql = ConnexionPostgresql();

final _depotVehicule = DepotVehiculePostgresql(
  connexionPostgresql: _connexionPostgresql,
);

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
      context.provide<DepotVehiculePostgresql>(
        () => _depotVehicule,
      ),
    );
  };
}