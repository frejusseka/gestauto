import 'package:dio/dio.dart';

import '../../donnees/depots/depot_authentification_impl.dart';
import '../../donnees/depots/depot_tableau_de_bord_impl.dart';
import '../../donnees/depots/depot_vehicule_impl.dart';
import '../../donnees/sources/distantes/source_authentification_distante_api.dart';
import '../../donnees/sources/distantes/source_tableau_de_bord_distante_api.dart';
import '../../donnees/sources/distantes/source_vehicule_distante_api.dart';
import '../../domaine/cas_utilisation/connecter_utilisateur.dart';
import '../../domaine/cas_utilisation/inscrire_utilisateur.dart';
import '../../domaine/cas_utilisation/obtenir_tableau_de_bord.dart';
import '../../domaine/cas_utilisation/obtenir_vehicules.dart';
import '../../presentation/accueil/controleur_tableau_de_bord.dart';
import '../../presentation/vehicules/controleur_vehicules.dart';
import '../reseau/configuration_dio.dart';
import '../stockage/stockage_session.dart';

class Dependances {
  static final StockageSession stockageSession =
      StockageSession();

  static final Dio dio = ConfigurationDio.creer(
    stockageSession: stockageSession,
  );

  static SourceVehiculeDistanteApi
      creerSourceVehiculeDistanteApi() {
    return SourceVehiculeDistanteApi(
      dio: dio,
    );
  }

  static DepotVehiculeImpl creerDepotVehicule() {
    return DepotVehiculeImpl(
      sourceDistante:
          creerSourceVehiculeDistanteApi(),
    );
  }

  static ObtenirVehicules creerObtenirVehicules() {
    return ObtenirVehicules(
      depot: creerDepotVehicule(),
    );
  }

  static ControleurVehicules
      creerControleurVehicules() {
    return ControleurVehicules(
      obtenirVehicules: creerObtenirVehicules(),
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

  static SourceTableauDeBordDistanteApi
      creerSourceTableauDeBordDistante() {
    return SourceTableauDeBordDistanteApi(
      dio: dio,
    );
  }

  static DepotTableauDeBordImpl
      creerDepotTableauDeBord() {
    return DepotTableauDeBordImpl(
      sourceDistante:
          creerSourceTableauDeBordDistante(),
    );
  }

  static ObtenirTableauDeBord
      creerObtenirTableauDeBord() {
    return ObtenirTableauDeBord(
      depot: creerDepotTableauDeBord(),
    );
  }

  static ControleurTableauDeBord
      creerControleurTableauDeBord() {
    return ControleurTableauDeBord(
      obtenirTableauDeBord:
          creerObtenirTableauDeBord(),
    );
  }
}