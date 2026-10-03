import 'package:dio/dio.dart';

import '../../donnees/sources/distantes/source_vehicule_distante_api.dart';
import '../reseau/configuration_dio.dart';
import '../stockage/stockage_session.dart';

class Dependances {
  static final StockageSession stockageSession =
      StockageSession();

  static final Dio dio = ConfigurationDio.creer(
    stockageSession: stockageSession,
  );

  static SourceVehiculeDistanteApi creerSourceVehiculeDistanteApi() {
    return SourceVehiculeDistanteApi(
      dio: dio,
    );
  }
}