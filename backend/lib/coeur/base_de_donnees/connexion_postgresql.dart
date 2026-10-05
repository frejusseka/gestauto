import 'dart:io';

import 'package:postgres/postgres.dart';

class ConnexionPostgresql {
  late final Connection _connexion;

  Future<void> ouvrir() async {
    final motDePasse = Platform.environment['GESTAUTO_DB_PASSWORD'];

    if (motDePasse == null || motDePasse.isEmpty) {
      throw StateError(
        'La variable d environnement GESTAUTO_DB_PASSWORD est absente.',
      );
    }

    _connexion = await Connection.open(
      Endpoint(
        host: 'localhost',
        port: 5432,
        database: 'gestauto',
        username: 'postgres',
        password: motDePasse,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );
  }

  Connection get connexion => _connexion;

  Future<void> fermer() async {
    await _connexion.close();
  }
}