import 'package:test/test.dart';

import '../../../lib/domaine/entites/alerte.dart';
import '../../../lib/domaine/entites/document.dart';
import '../../../lib/domaine/entites/entretien.dart';
import '../../../lib/domaine/entites/type_document.dart';
import '../../../lib/domaine/entites/vehicule.dart';
import '../../../lib/donnees/services/service_alertes_impl.dart';

void main() {
  final service = ServiceAlertesImpl();

  final dateActuelle = DateTime(2026, 10, 2);

  Vehicule creerVehicule({
    required String id,
    required TypeVehicule type,
    int kilometrage = 0,
  }) {
    return Vehicule(
      id: id,
      utilisateurId: 'utilisateur-test',
      type: type,
      marque: 'Toyota',
      modele: 'Corolla',
      immatriculation: 'TEST-001',
      annee: 2024,
      kilometrage: kilometrage,
      dateAcquisition: DateTime(2024, 1, 1),
      prixAcquisition: 10000000,
      statut: StatutVehicule.enService,
      montantVersementAttendu: 20000,
    );
  }

  TypeDocument creerTypeDocument() {
    return TypeDocument(
      id: 'type-document-1',
      utilisateurId: 'utilisateur-test',
      nom: 'Assurance',
    );
  }

  test(
    'génère une alerte pour un document expirant dans 30 jours',
    () {
      final vehicule = creerVehicule(
        id: 'vehicule-1',
        type: TypeVehicule.voiture,
      );

      final document = Document(
        id: 'document-1',
        vehiculeId: vehicule.id,
        typeDocumentId: 'type-document-1',
        dateEmission: DateTime(2026, 1, 1),
        dateExpiration: DateTime(2026, 11, 1),
      );

      final alertes = service.genererAlertes(
        vehicules: [vehicule],
        documents: [document],
        typesDocuments: [creerTypeDocument()],
        entretiens: [],
        dateActuelle: dateActuelle,
      );

      expect(alertes, hasLength(1));
      expect(alertes.first.type, TypeAlerte.document);
      expect(
        alertes.first.niveau,
        NiveauAlerte.avertissement,
      );
      expect(
        alertes.first.titre,
        'Échéance du document proche',
      );
    },
  );

  test(
    'génère une alerte urgente pour un document expiré',
    () {
      final vehicule = creerVehicule(
        id: 'vehicule-2',
        type: TypeVehicule.voiture,
      );

      final document = Document(
        id: 'document-2',
        vehiculeId: vehicule.id,
        typeDocumentId: 'type-document-1',
        dateEmission: DateTime(2025, 1, 1),
        dateExpiration: DateTime(2026, 9, 30),
      );

      final alertes = service.genererAlertes(
        vehicules: [vehicule],
        documents: [document],
        typesDocuments: [creerTypeDocument()],
        entretiens: [],
        dateActuelle: dateActuelle,
      );

      expect(alertes, hasLength(1));
      expect(alertes.first.type, TypeAlerte.document);
      expect(
        alertes.first.niveau,
        NiveauAlerte.urgent,
      );
      expect(
        alertes.first.titre,
        'Document arrivé à échéance',
      );
    },
  );

  test(
    'génère une alerte kilométrique pour une voiture à 1000 km',
    () {
      final vehicule = creerVehicule(
        id: 'vehicule-3',
        type: TypeVehicule.voiture,
        kilometrage: 49000,
      );

      final entretien = Entretien(
        id: 'entretien-1',
        vehiculeId: vehicule.id,
        type: 'Vidange',
        date: DateTime(2026, 9, 1),
        kilometrage: 40000,
        montant: 50000,
        prochainKilometrage: 50000,
      );

      final alertes = service.genererAlertes(
        vehicules: [vehicule],
        documents: [],
        typesDocuments: [],
        entretiens: [entretien],
        dateActuelle: dateActuelle,
      );

      expect(alertes, hasLength(1));
      expect(alertes.first.type, TypeAlerte.entretien);
      expect(
        alertes.first.niveau,
        NiveauAlerte.avertissement,
      );
    },
  );

  test(
    'génère une alerte kilométrique pour une moto à 500 km',
    () {
      final vehicule = creerVehicule(
        id: 'vehicule-4',
        type: TypeVehicule.moto,
        kilometrage: 9500,
      );

      final entretien = Entretien(
        id: 'entretien-2',
        vehiculeId: vehicule.id,
        type: 'Vidange',
        date: DateTime(2026, 9, 1),
        kilometrage: 5000,
        montant: 15000,
        prochainKilometrage: 10000,
      );

      final alertes = service.genererAlertes(
        vehicules: [vehicule],
        documents: [],
        typesDocuments: [],
        entretiens: [entretien],
        dateActuelle: dateActuelle,
      );

      expect(alertes, hasLength(1));
      expect(alertes.first.type, TypeAlerte.entretien);
      expect(
        alertes.first.niveau,
        NiveauAlerte.avertissement,
      );
    },
  );

  test(
    'ne génère pas d alerte kilométrique pour une voiture à plus de 1000 km',
    () {
      final vehicule = creerVehicule(
        id: 'vehicule-5',
        type: TypeVehicule.voiture,
        kilometrage: 48000,
      );

      final entretien = Entretien(
        id: 'entretien-3',
        vehiculeId: vehicule.id,
        type: 'Vidange',
        date: DateTime(2026, 9, 1),
        kilometrage: 40000,
        montant: 50000,
        prochainKilometrage: 50000,
      );

      final alertes = service.genererAlertes(
        vehicules: [vehicule],
        documents: [],
        typesDocuments: [],
        entretiens: [entretien],
        dateActuelle: dateActuelle,
      );

      expect(alertes, isEmpty);
    },
  );

  test(
    'génère une alerte urgente lorsque le kilométrage est dépassé',
    () {
      final vehicule = creerVehicule(
        id: 'vehicule-6',
        type: TypeVehicule.moto,
        kilometrage: 10500,
      );

      final entretien = Entretien(
        id: 'entretien-4',
        vehiculeId: vehicule.id,
        type: 'Vidange',
        date: DateTime(2026, 9, 1),
        kilometrage: 5000,
        montant: 15000,
        prochainKilometrage: 10000,
      );

      final alertes = service.genererAlertes(
        vehicules: [vehicule],
        documents: [],
        typesDocuments: [],
        entretiens: [entretien],
        dateActuelle: dateActuelle,
      );

      expect(alertes, hasLength(1));
      expect(alertes.first.type, TypeAlerte.entretien);
      expect(
        alertes.first.niveau,
        NiveauAlerte.urgent,
      );
    },
  );

    test(
    'génère plusieurs alertes pour un même véhicule',
    () {
      final vehicule = creerVehicule(
        id: 'vehicule-7',
        type: TypeVehicule.voiture,
        kilometrage: 49200,
      );

      final typeDocument = creerTypeDocument();

      final document = Document(
        id: 'document-7',
        vehiculeId: vehicule.id,
        typeDocumentId: typeDocument.id,
        dateEmission: DateTime(2026, 1, 1),
        dateExpiration: DateTime(2026, 10, 22),
      );

      final entretien = Entretien(
        id: 'entretien-7',
        vehiculeId: vehicule.id,
        type: 'Vidange',
        date: DateTime(2026, 9, 1),
        kilometrage: 40000,
        montant: 50000,
        prochainKilometrage: 50000,
      );

      final alertes = service.genererAlertes(
        vehicules: [vehicule],
        documents: [document],
        typesDocuments: [typeDocument],
        entretiens: [entretien],
        dateActuelle: dateActuelle,
      );

      expect(alertes, hasLength(2));

      expect(
        alertes.any(
          (alerte) => alerte.type == TypeAlerte.document,
        ),
        isTrue,
      );

      expect(
        alertes.any(
          (alerte) => alerte.type == TypeAlerte.entretien,
        ),
        isTrue,
      );
    },
  );
}