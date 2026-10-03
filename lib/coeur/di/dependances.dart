import 'package:dio/dio.dart';

import '../../donnees/sources/distantes/source_vehicule_distante_api.dart';
import '../reseau/configuration_dio.dart';

class Dependances {
  static final Dio dio = ConfigurationDio.creer();

  static SourceVehiculeDistanteApi creerSourceVehiculeDistanteApi() {
    return SourceVehiculeDistanteApi(
      dio: dio,
    );
  }
}