import 'package:dio/dio.dart';

import '../../donnees/depots/depot_authentification_impl.dart';
import '../../donnees/depots/depot_categorie_depense_impl.dart';
import '../../donnees/depots/depot_depense_impl.dart';
import '../../donnees/depots/depot_panne_impl.dart';
import '../../donnees/depots/depot_tableau_de_bord_impl.dart';
import '../../donnees/depots/depot_vehicule_impl.dart';
import '../../donnees/depots/depot_versement_impl.dart';
import '../../donnees/sources/distantes/source_authentification_distante_api.dart';
import '../../donnees/sources/distantes/source_categorie_depense_distante_api.dart';
import '../../donnees/sources/distantes/source_depense_distante_api.dart';
import '../../donnees/sources/distantes/source_panne_distante_api.dart';
import '../../donnees/sources/distantes/source_tableau_de_bord_distante_api.dart';
import '../../donnees/sources/distantes/source_vehicule_distante_api.dart';
import '../../donnees/sources/distantes/source_versement_distante_api.dart';
import '../../donnees/sources/locales/source_vehicule_locale.dart';
import '../../domaine/cas_utilisation/ajouter_vehicule.dart';
import '../../domaine/cas_utilisation/connecter_utilisateur.dart';
import '../../domaine/cas_utilisation/creer_categorie_depense.dart';
import '../../domaine/cas_utilisation/creer_depense.dart';
import '../../domaine/cas_utilisation/creer_panne.dart';
import '../../domaine/cas_utilisation/creer_versement.dart';
import '../../domaine/cas_utilisation/inscrire_utilisateur.dart';
import '../../domaine/cas_utilisation/modifier_panne.dart';
import '../../domaine/cas_utilisation/obtenir_categories_depense.dart';
import '../../domaine/cas_utilisation/obtenir_depenses.dart';
import '../../domaine/cas_utilisation/obtenir_pannes.dart';
import '../../domaine/cas_utilisation/obtenir_tableau_de_bord.dart';
import '../../domaine/cas_utilisation/obtenir_vehicules.dart';
import '../../domaine/cas_utilisation/obtenir_versements.dart';
import '../../domaine/cas_utilisation/supprimer_panne.dart';
import '../../presentation/accueil/controleur_tableau_de_bord.dart';
import '../../presentation/depenses/controleur_categories_depenses.dart';
import '../../presentation/depenses/controleur_depenses.dart';
import '../../presentation/pannes/controleur_pannes.dart';
import '../../presentation/vehicules/controleur_vehicules.dart';
import '../../presentation/versements/controleur_versements.dart';
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

  static SourceVehiculeLocale
      creerSourceVehiculeLocale() {
    return SourceVehiculeLocale();
  }

  static DepotVehiculeImpl creerDepotVehicule() {
    return DepotVehiculeImpl(
      sourceDistante:
          creerSourceVehiculeDistanteApi(),
      sourceLocale:
          creerSourceVehiculeLocale(),
    );
  }

  static ObtenirVehicules creerObtenirVehicules() {
    return ObtenirVehicules(
      depot: creerDepotVehicule(),
    );
  }

  static AjouterVehicule creerAjouterVehicule() {
    return AjouterVehicule(
      depot: creerDepotVehicule(),
    );
  }

  static ControleurVehicules
      creerControleurVehicules() {
    return ControleurVehicules(
      obtenirVehicules:
          creerObtenirVehicules(),
      ajouterVehicule:
          creerAjouterVehicule(),
    );
  }

  static DepotAuthentificationImpl
      creerDepotAuthentification() {
    return DepotAuthentificationImpl(
      sourceDistante:
          SourceAuthentificationDistanteApi(
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

  static SourceVersementDistanteApi
      creerSourceVersementDistante() {
    return SourceVersementDistanteApi(
      dio: dio,
    );
  }

  static DepotVersementImpl
      creerDepotVersement() {
    return DepotVersementImpl(
      sourceDistante:
          creerSourceVersementDistante(),
    );
  }

  static ObtenirVersements
      creerObtenirVersements() {
    return ObtenirVersements(
      depot: creerDepotVersement(),
    );
  }

  static CreerVersement
      creerCreerVersement() {
    return CreerVersement(
      depot: creerDepotVersement(),
    );
  }

  static ControleurVersements
      creerControleurVersements() {
    return ControleurVersements(
      obtenirVersements:
          creerObtenirVersements(),
      creerVersement:
          creerCreerVersement(),
    );
  }

  static SourceDepenseDistanteApi
      creerSourceDepenseDistante() {
    return SourceDepenseDistanteApi(
      dio: dio,
    );
  }

  static DepotDepenseImpl creerDepotDepense() {
    return DepotDepenseImpl(
      sourceDistante:
          creerSourceDepenseDistante(),
    );
  }

  static ObtenirDepenses creerObtenirDepenses() {
    return ObtenirDepenses(
      depot: creerDepotDepense(),
    );
  }

  static CreerDepense creerCreerDepense() {
    return CreerDepense(
      depot: creerDepotDepense(),
    );
  }

  static ControleurDepenses
      creerControleurDepenses() {
    return ControleurDepenses(
      obtenirDepenses:
          creerObtenirDepenses(),
      creerDepense:
          creerCreerDepense(),
    );
  }

  static SourceCategorieDepenseDistanteApi
      creerSourceCategorieDepenseDistante() {
    return SourceCategorieDepenseDistanteApi(
      dio: dio,
    );
  }

  static DepotCategorieDepenseImpl
      creerDepotCategorieDepense() {
    return DepotCategorieDepenseImpl(
      sourceDistante:
          creerSourceCategorieDepenseDistante(),
    );
  }

  static ObtenirCategoriesDepense
      creerObtenirCategoriesDepense() {
    return ObtenirCategoriesDepense(
      depot: creerDepotCategorieDepense(),
    );
  }

  static CreerCategorieDepense
      creerCreerCategorieDepense() {
    return CreerCategorieDepense(
      depot: creerDepotCategorieDepense(),
    );
  }

  static ControleurCategoriesDepenses
      creerControleurCategoriesDepenses() {
    return ControleurCategoriesDepenses(
      obtenirCategoriesDepense:
          creerObtenirCategoriesDepense(),
      creerCategorieDepense:
          creerCreerCategorieDepense(),
    );
  }

  static SourcePanneDistanteApi
      creerSourcePanneDistante() {
    return SourcePanneDistanteApi(
      dio: dio,
    );
  }

  static DepotPanneImpl creerDepotPanne() {
    return DepotPanneImpl(
      sourceDistante:
          creerSourcePanneDistante(),
    );
  }

  static ObtenirPannes creerObtenirPannes() {
    return ObtenirPannes(
      depot: creerDepotPanne(),
    );
  }

  static CreerPanne creerCreerPanne() {
    return CreerPanne(
      depot: creerDepotPanne(),
    );
  }

  static ModifierPanne creerModifierPanne() {
    return ModifierPanne(
      depot: creerDepotPanne(),
    );
  }

  static SupprimerPanne creerSupprimerPanne() {
    return SupprimerPanne(
      depot: creerDepotPanne(),
    );
  }

  static ControleurPannes
      creerControleurPannes() {
    return ControleurPannes(
      obtenirPannes:
          creerObtenirPannes(),
      creerPanne:
          creerCreerPanne(),
      modifierPanne:
          creerModifierPanne(),
      supprimerPanne:
          creerSupprimerPanne(),
    );
  }
}