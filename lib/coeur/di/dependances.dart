import 'package:dio/dio.dart';

import '../../donnees/depots/depot_authentification_impl.dart';
import '../../donnees/sources/distantes/source_authentification_distante_api.dart';
import '../../donnees/sources/distantes/source_vehicule_distante_api.dart';
import '../../domaine/cas_utilisation/connecter_utilisateur.dart';
import '../../domaine/cas_utilisation/inscrire_utilisateur.dart';
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

  static DepotAuthentificationImpl
      creerDepotAuthentification() {
    return DepotAuthentificationImpl(
      sourceDistante: SourceAuthentificationDistanteApi(
        dio: dio,
      ),
    );
  }

  static ConnecterUtilisateur
      creerConnecterUtilisateur() {
    return ConnecterUtilisateur(
      depot: creerDepotAuthentification(),
      stockageSession: stockageSession,
    );
  }

  static InscrireUtilisateur
      creerInscrireUtilisateur() {
    return InscrireUtilisateur(
      depot: creerDepotAuthentification(),
    );
  }
}