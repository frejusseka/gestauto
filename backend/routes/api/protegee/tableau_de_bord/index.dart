import 'package:dart_frog/dart_frog.dart';

import 'package:gestauto_backend/domaine/cas_utilisation/tableau_de_bord/obtenir_tableau_de_bord.dart';
import 'package:gestauto_backend/domaine/entites/tableau_de_bord.dart';
import 'package:gestauto_backend/donnees/depots/depot_depense_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_document_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_entretien_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_panne_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_type_document_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_vehicule_postgresql.dart';
import 'package:gestauto_backend/donnees/depots/depot_versement_postgresql.dart';
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

  final parametres =
      context.request.uri.queryParameters;

  final resultatPeriode =
      _obtenirPeriode(parametres);

  if (resultatPeriode == null) {
    return Response.json(
      statusCode: 400,
      body: {
        'message':
            'Les paramètres debut et fin doivent être des dates valides au format YYYY-MM-DD.',
      },
    );
  }

  final obtenirTableauDeBord = ObtenirTableauDeBord(
    depotVehicule:
        context.read<DepotVehiculePostgresql>(),
    depotVersement:
        context.read<DepotVersementPostgresql>(),
    depotDepense:
        context.read<DepotDepensePostgresql>(),
    depotPanne:
        context.read<DepotPannePostgresql>(),
    depotEntretien:
        context.read<DepotEntretienPostgresql>(),
    depotDocument:
        context.read<DepotDocumentPostgresql>(),
    depotTypeDocument:
        context.read<DepotTypeDocumentPostgresql>(),
    serviceAlertes:
        context.read<ServiceAlertesImpl>(),
  );

  try {
    final tableauDeBord =
        await obtenirTableauDeBord.executer(
      utilisateurId: utilisateurId,
      debutPeriode: resultatPeriode.debut,
      finPeriode: resultatPeriode.fin,
    );

    return Response.json(
      statusCode: 200,
      body: _convertirTableauDeBord(
        tableauDeBord,
      ),
    );
  } catch (erreur) {
    return Response.json(
      statusCode: 500,
      body: {
        'message':
            'Impossible de récupérer le tableau de bord.',
      },
    );
  }
}

_ResultatPeriode? _obtenirPeriode(
  Map<String, String> parametres,
) {
  final debut = parametres['debut'];
  final fin = parametres['fin'];

  final maintenant = DateTime.now();

  if (debut == null && fin == null) {
    final debutMois = DateTime(
      maintenant.year,
      maintenant.month,
      1,
    );

    final finMois = DateTime(
      maintenant.year,
      maintenant.month + 1,
      0,
    );

    return _ResultatPeriode(
      debut: debutMois,
      fin: finMois,
    );
  }

  if (debut == null || fin == null) {
    return null;
  }

  final dateDebut = DateTime.tryParse(debut);
  final dateFin = DateTime.tryParse(fin);

  if (dateDebut == null || dateFin == null) {
    return null;
  }

  if (dateFin.isBefore(dateDebut)) {
    return null;
  }

  return _ResultatPeriode(
    debut: dateDebut,
    fin: dateFin,
  );
}

Map<String, dynamic> _convertirTableauDeBord(
  TableauDeBord tableauDeBord,
) {
  return {
    'periode': {
      'debut': _formaterDate(tableauDeBord.debutPeriode),
      'fin': _formaterDate(tableauDeBord.finPeriode),
    },
    'nombreVehicules':
        tableauDeBord.nombreVehicules,
    'montantVersementsAttendus':
        tableauDeBord.montantVersementsAttendus,
    'montantVersementsRecus':
        tableauDeBord.montantVersementsRecus,
    'ecartVersements':
        tableauDeBord.ecartVersements,
    'montantDepenses':
        tableauDeBord.montantDepenses,
    'resultatEstime':
        tableauDeBord.resultatEstime,
    'nombrePannes':
        tableauDeBord.nombrePannes,
    'nombreEntretiensAVenir':
        tableauDeBord.nombreEntretiensAVenir,
    'nombreAlertes':
        tableauDeBord.nombreAlertes,
    'performancesVehicules':
        tableauDeBord.performancesVehicules
            .map(_convertirPerformanceVehicule)
            .toList(),
  };
}

Map<String, dynamic> _convertirPerformanceVehicule(
  PerformanceVehicule performance,
) {
  return {
    'vehiculeId': performance.vehicule.id,
    'marque': performance.vehicule.marque,
    'modele': performance.vehicule.modele,
    'immatriculation':
        performance.vehicule.immatriculation,
    'versementsAttendus':
        performance.versementsAttendus,
    'versementsRecus':
        performance.versementsRecus,
    'ecartVersements':
        performance.ecartVersements,
    'depenses':
        performance.depenses,
    'resultatEstime':
        performance.resultatEstime,
  };
}

String _formaterDate(DateTime date) {
  final mois = date.month.toString().padLeft(2, '0');
  final jour = date.day.toString().padLeft(2, '0');

  return '${date.year}-$mois-$jour';
}

class _ResultatPeriode {
  final DateTime debut;
  final DateTime fin;

  _ResultatPeriode({
    required this.debut,
    required this.fin,
  });
}