import '../../domaine/entites/alerte.dart';
import '../../domaine/entites/document.dart';
import '../../domaine/entites/entretien.dart';
import '../../domaine/entites/type_document.dart';
import '../../domaine/entites/vehicule.dart';
import '../../domaine/services/service_alertes.dart';

class ServiceAlertesImpl implements ServiceAlertes {
  static const int _nombreJoursAlerteDocument = 30;
  static const int _nombreJoursAlerteEntretien = 30;
  static const int _kilometresAlerteVoiture = 1000;
  static const int _kilometresAlerteMoto = 500;

  @override
  List<Alerte> genererAlertes({
    required List<Vehicule> vehicules,
    required List<Document> documents,
    required List<TypeDocument> typesDocuments,
    required List<Entretien> entretiens,
    required DateTime dateActuelle,
  }) {
    final alertes = <Alerte>[];

    for (final document in documents) {
      final vehicule = vehicules.cast<Vehicule?>().firstWhere(
            (vehicule) => vehicule?.id == document.vehiculeId,
            orElse: () => null,
          );

      if (vehicule == null) {
        continue;
      }

      final typeDocument = typesDocuments.cast<TypeDocument?>().firstWhere(
            (type) => type?.id == document.typeDocumentId,
            orElse: () => null,
          );

      if (typeDocument == null) {
        continue;
      }

      final difference =
          document.dateExpiration.difference(dateActuelle).inDays;

      if (document.dateExpiration.isBefore(dateActuelle)) {
        alertes.add(
          Alerte(
            type: TypeAlerte.document,
            vehiculeId: document.vehiculeId,
            titre: 'Document arrivé à échéance',
            message:
                'Le document ${typeDocument.nom} du véhicule '
                '${vehicule.marque} ${vehicule.modele} est arrivé à échéance.',
            niveau: NiveauAlerte.urgent,
          ),
        );
      } else if (difference <= _nombreJoursAlerteDocument) {
        alertes.add(
          Alerte(
            type: TypeAlerte.document,
            vehiculeId: document.vehiculeId,
            titre: 'Échéance du document proche',
            message:
                'Le document ${typeDocument.nom} du véhicule '
                '${vehicule.marque} ${vehicule.modele} arrive à échéance '
                'dans $difference jours.',
            niveau: NiveauAlerte.avertissement,
          ),
        );
      }
    }

    for (final entretien in entretiens) {
      final vehicule = vehicules.cast<Vehicule?>().firstWhere(
            (vehicule) => vehicule?.id == entretien.vehiculeId,
            orElse: () => null,
          );

      if (vehicule == null) {
        continue;
      }

      final prochaineDate = entretien.prochaineDate;
      final prochainKilometrage = entretien.prochainKilometrage;

      bool dateUrgente = false;
      bool dateProche = false;
      int? joursRestants;

      if (prochaineDate != null) {
        final difference =
            prochaineDate.difference(dateActuelle).inDays;

        if (prochaineDate.isBefore(dateActuelle)) {
          dateUrgente = true;
        } else if (difference <= _nombreJoursAlerteEntretien) {
          dateProche = true;
          joursRestants = difference;
        }
      }

      bool kilometrageUrgent = false;
      bool kilometrageProche = false;
      int? kilometresRestants;

      if (prochainKilometrage != null) {
        kilometresRestants =
            prochainKilometrage - vehicule.kilometrage;

        final seuilKilometrique =
            vehicule.type == TypeVehicule.voiture
                ? _kilometresAlerteVoiture
                : _kilometresAlerteMoto;

        if (kilometresRestants <= 0) {
          kilometrageUrgent = true;
        } else if (kilometresRestants <= seuilKilometrique) {
          kilometrageProche = true;
        }
      }

      final entretienUrgent = dateUrgente || kilometrageUrgent;
      final entretienProche = dateProche || kilometrageProche;

      if (!entretienUrgent && !entretienProche) {
        continue;
      }

      final niveau = entretienUrgent
          ? NiveauAlerte.urgent
          : NiveauAlerte.avertissement;

      String message;

      if (entretienUrgent) {
        final details = <String>[];

        if (dateUrgente) {
          details.add('la date prévue est dépassée');
        }

        if (kilometrageUrgent) {
          details.add('le kilométrage prévu est dépassé');
        }

        message =
            'Un entretien du véhicule ${vehicule.marque} '
            '${vehicule.modele} est en retard : '
            '${details.join(' et ')}.';
      } else {
        final details = <String>[];

        if (dateProche && joursRestants != null) {
          details.add('dans $joursRestants jours');
        }

        if (kilometrageProche && kilometresRestants != null) {
          details.add('dans $kilometresRestants km');
        }

        message =
            'Le prochain entretien du véhicule '
            '${vehicule.marque} ${vehicule.modele} est prévu '
            '${details.join(' ou ')}.';
      }

      alertes.add(
        Alerte(
          type: TypeAlerte.entretien,
          vehiculeId: entretien.vehiculeId,
          titre: entretienUrgent
              ? 'Entretien en retard'
              : 'Entretien proche',
          message: message,
          niveau: niveau,
        ),
      );
    }

    return alertes;
  }
}