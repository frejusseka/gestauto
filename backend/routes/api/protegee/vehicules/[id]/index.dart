import 'package:dart_frog/dart_frog.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/vehicule/modifier_vehicule.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/vehicule/obtenir_vehicule.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/vehicule/supprimer_vehicule.dart';
import 'package:gestauto_backend/domaine/entites/vehicule.dart';
import 'package:gestauto_backend/donnees/depots/depot_vehicule_postgresql.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _obtenirVehicule(
        context,
        id,
      );

    case HttpMethod.put:
      return _modifierVehicule(
        context,
        id,
      );

    case HttpMethod.delete:
      return _supprimerVehicule(
        context,
        id,
      );

    default:
      return Response.json(
        statusCode: 405,
        body: {
          'message': 'Méthode HTTP non autorisée.',
        },
      );
  }
}

Future<Response> _obtenirVehicule(
  RequestContext context,
  String id,
) async {
  try {
    final utilisateurId =
        context.read<Map<String, dynamic>>()['utilisateurId']
            as String?;

    if (utilisateurId == null || utilisateurId.isEmpty) {
      return Response.json(
        statusCode: 401,
        body: {
          'message': 'Utilisateur authentifié introuvable.',
        },
      );
    }

    final depotVehicule =
        context.read<DepotVehiculePostgresql>();

    final obtenirVehicule = ObtenirVehicule(
      depot: depotVehicule,
    );

    final vehicule = await obtenirVehicule.executer(
      utilisateurId: utilisateurId,
      vehiculeId: id,
    );

    if (vehicule == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Véhicule introuvable.',
        },
      );
    }

    return Response.json(
      statusCode: 200,
      body: {
        'vehicule': _convertirVehiculeEnJson(vehicule),
      },
    );
  } catch (erreur) {
    return Response.json(
      statusCode: 500,
      body: {
        'message': 'Une erreur interne est survenue.',
      },
    );
  }
}

Future<Response> _modifierVehicule(
  RequestContext context,
  String id,
) async {
  try {
    final utilisateurId =
        context.read<Map<String, dynamic>>()['utilisateurId']
            as String?;

    if (utilisateurId == null || utilisateurId.isEmpty) {
      return Response.json(
        statusCode: 401,
        body: {
          'message': 'Utilisateur authentifié introuvable.',
        },
      );
    }

    final donnees = await context.request.json();

    if (donnees is! Map<String, dynamic>) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Le corps de la requête doit être un objet JSON.',
        },
      );
    }

    final type = donnees['type'] as String?;
    final marque = donnees['marque'] as String?;
    final modele = donnees['modele'] as String?;
    final immatriculation =
        donnees['immatriculation'] as String?;
    final annee = donnees['annee'] as int?;
    final kilometrage = donnees['kilometrage'] as int?;
    final dateAcquisition =
        donnees['dateAcquisition'] as String?;
    final prixAcquisition =
        (donnees['prixAcquisition'] as num?)?.toDouble();
    final statut = donnees['statut'] as String?;
    final montantVersementAttendu =
        (donnees['montantVersementAttendu'] as num?)?.toDouble();
    final photo = donnees['photo'] as String?;

    if (type == null ||
        marque == null ||
        modele == null ||
        immatriculation == null ||
        annee == null ||
        kilometrage == null ||
        dateAcquisition == null ||
        prixAcquisition == null ||
        statut == null ||
        montantVersementAttendu == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message':
              'Les champs obligatoires du véhicule sont incomplets.',
        },
      );
    }

    final typeVehicule = _convertirType(type);

    if (typeVehicule == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message': 'Type de véhicule invalide.',
        },
      );
    }

    final statutVehicule = _convertirStatut(statut);

    if (statutVehicule == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'message': 'Statut de véhicule invalide.',
        },
      );
    }

    final depotVehicule =
        context.read<DepotVehiculePostgresql>();

    final obtenirVehicule = ObtenirVehicule(
      depot: depotVehicule,
    );

    final vehiculeExistant =
        await obtenirVehicule.executer(
      utilisateurId: utilisateurId,
      vehiculeId: id,
    );

    if (vehiculeExistant == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Véhicule introuvable.',
        },
      );
    }

    final modifierVehicule = ModifierVehicule(
      depot: depotVehicule,
    );

    final vehicule = Vehicule(
      id: id,
      utilisateurId: utilisateurId,
      type: typeVehicule,
      marque: marque,
      modele: modele,
      immatriculation: immatriculation,
      annee: annee,
      kilometrage: kilometrage,
      dateAcquisition: DateTime.parse(dateAcquisition),
      prixAcquisition: prixAcquisition,
      statut: statutVehicule,
      montantVersementAttendu: montantVersementAttendu,
      photo: photo,
    );

    final vehiculeModifie =
        await modifierVehicule.executer(vehicule);

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Véhicule modifié avec succès.',
        'vehicule':
            _convertirVehiculeEnJson(vehiculeModifie),
      },
    );
  } on FormatException {
    return Response.json(
      statusCode: 400,
      body: {
        'message': 'La date d acquisition est invalide.',
      },
    );
  } catch (erreur) {
    return Response.json(
      statusCode: 500,
      body: {
        'message': 'Une erreur interne est survenue.',
      },
    );
  }
}

Future<Response> _supprimerVehicule(
  RequestContext context,
  String id,
) async {
  try {
    final utilisateurId =
        context.read<Map<String, dynamic>>()['utilisateurId']
            as String?;

    if (utilisateurId == null || utilisateurId.isEmpty) {
      return Response.json(
        statusCode: 401,
        body: {
          'message': 'Utilisateur authentifié introuvable.',
        },
      );
    }

    final depotVehicule =
        context.read<DepotVehiculePostgresql>();

    final obtenirVehicule = ObtenirVehicule(
      depot: depotVehicule,
    );

    final vehiculeExistant =
        await obtenirVehicule.executer(
      utilisateurId: utilisateurId,
      vehiculeId: id,
    );

    if (vehiculeExistant == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'message': 'Véhicule introuvable.',
        },
      );
    }

    final supprimerVehicule = SupprimerVehicule(
      depot: depotVehicule,
    );

    await supprimerVehicule.executer(
      utilisateurId: utilisateurId,
      vehiculeId: id,
    );

    return Response.json(
      statusCode: 200,
      body: {
        'message': 'Véhicule supprimé avec succès.',
      },
    );
  } catch (erreur) {
    return Response.json(
      statusCode: 500,
      body: {
        'message': 'Une erreur interne est survenue.',
      },
    );
  }
}

Map<String, dynamic> _convertirVehiculeEnJson(
  Vehicule vehicule,
) {
  return {
    'id': vehicule.id,
    'utilisateurId': vehicule.utilisateurId,
    'type': vehicule.type.name,
    'marque': vehicule.marque,
    'modele': vehicule.modele,
    'immatriculation': vehicule.immatriculation,
    'annee': vehicule.annee,
    'kilometrage': vehicule.kilometrage,
    'dateAcquisition':
        vehicule.dateAcquisition.toIso8601String(),
    'prixAcquisition': vehicule.prixAcquisition,
    'statut': vehicule.statut.name,
    'montantVersementAttendu':
        vehicule.montantVersementAttendu,
    'photo': vehicule.photo,
  };
}

TypeVehicule? _convertirType(String type) {
  switch (type) {
    case 'voiture':
      return TypeVehicule.voiture;
    case 'moto':
      return TypeVehicule.moto;
    default:
      return null;
  }
}

StatutVehicule? _convertirStatut(String statut) {
  switch (statut) {
    case 'enService':
      return StatutVehicule.enService;
    case 'disponible':
      return StatutVehicule.disponible;
    case 'enMaintenance':
      return StatutVehicule.enMaintenance;
    case 'enPanne':
      return StatutVehicule.enPanne;
    case 'horsService':
      return StatutVehicule.horsService;
    default:
      return null;
  }
}