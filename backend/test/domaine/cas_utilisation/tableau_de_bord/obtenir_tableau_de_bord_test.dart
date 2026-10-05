import 'package:test/test.dart';

import 'package:gestauto_backend/domaine/cas_utilisation/tableau_de_bord/obtenir_tableau_de_bord.dart';
import 'package:gestauto_backend/domaine/depots/depot_depense.dart';
import 'package:gestauto_backend/domaine/depots/depot_document.dart';
import 'package:gestauto_backend/domaine/depots/depot_entretien.dart';
import 'package:gestauto_backend/domaine/depots/depot_panne.dart';
import 'package:gestauto_backend/domaine/depots/depot_type_document.dart';
import 'package:gestauto_backend/domaine/depots/depot_vehicule.dart';
import 'package:gestauto_backend/domaine/depots/depot_versement.dart';
import 'package:gestauto_backend/domaine/entites/alerte.dart';
import 'package:gestauto_backend/domaine/entites/depense.dart';
import 'package:gestauto_backend/domaine/entites/document.dart';
import 'package:gestauto_backend/domaine/entites/entretien.dart';
import 'package:gestauto_backend/domaine/entites/panne.dart';
import 'package:gestauto_backend/domaine/entites/type_document.dart';
import 'package:gestauto_backend/domaine/entites/vehicule.dart';
import 'package:gestauto_backend/domaine/entites/versement.dart';
import 'package:gestauto_backend/domaine/services/service_alertes.dart';

const utilisateurId = 'utilisateur-test';
const vehiculeId = 'vehicule-test';

final vehicule = Vehicule(
  id: vehiculeId,
  utilisateurId: utilisateurId,
  type: TypeVehicule.voiture,
  marque: 'Toyota',
  modele: 'Corolla',
  immatriculation: 'TEST-001',
  annee: 2024,
  kilometrage: 15000,
  dateAcquisition: DateTime(2024, 1, 1),
  prixAcquisition: 10000000,
  statut: StatutVehicule.enService,
  montantVersementAttendu: 20000,
);

final versement1 = Versement(
  id: 'versement-1',
  vehiculeId: vehiculeId,
  date: DateTime(2026, 10, 1),
  montantAttendu: 20000,
  montantVerse: 20000,
);

final versement2 = Versement(
  id: 'versement-2',
  vehiculeId: vehiculeId,
  date: DateTime(2026, 10, 2),
  montantAttendu: 20000,
  montantVerse: 15000,
);

final versementHorsPeriode = Versement(
  id: 'versement-3',
  vehiculeId: vehiculeId,
  date: DateTime(2026, 9, 30),
  montantAttendu: 20000,
  montantVerse: 20000,
);

final depense = Depense(
  id: 'depense-1',
  vehiculeId: vehiculeId,
  categorieId: 'categorie-1',
  date: DateTime(2026, 10, 2),
  montant: 10000,
  description: 'Vidange',
);

final depenseHorsPeriode = Depense(
  id: 'depense-2',
  vehiculeId: vehiculeId,
  categorieId: 'categorie-1',
  date: DateTime(2026, 9, 30),
  montant: 50000,
  description: 'Depense hors periode',
);

final panne = Panne(
  id: 'panne-1',
  vehiculeId: vehiculeId,
  date: DateTime(2026, 10, 2),
  description: 'Pneu creve',
  gravite: GravitePanne.moyenne,
  resolue: false,
);

final panneHorsPeriode = Panne(
  id: 'panne-2',
  vehiculeId: vehiculeId,
  date: DateTime(2026, 9, 30),
  description: 'Ancienne panne',
  gravite: GravitePanne.faible,
  resolue: true,
  dateResolution: DateTime(2026, 10, 1),
);

final entretien = Entretien(
  id: 'entretien-1',
  vehiculeId: vehiculeId,
  type: 'Vidange',
  date: DateTime(2026, 10, 2),
  kilometrage: 15000,
  montant: 50000,
  prochainKilometrage: 16000,
  prochaineDate: DateTime(2026, 10, 20),
  notes: 'Prochaine vidange',
);

final typeDocument = TypeDocument(
  id: 'type-document-1',
  utilisateurId: utilisateurId,
  nom: 'Assurance',
);

final document = Document(
  id: 'document-1',
  vehiculeId: vehiculeId,
  typeDocumentId: typeDocument.id,
  numero: 'ASS-001',
  dateEmission: DateTime(2026, 1, 1),
  dateExpiration: DateTime(2026, 10, 20),
  notes: 'Assurance de test',
);

class FauxDepotVehicule implements DepotVehicule {
  @override
  Future<List<Vehicule>> obtenirTous(String utilisateurId) async {
    return [vehicule];
  }

  @override
  Future<Vehicule?> obtenirParId({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    return vehicule;
  }

  @override
  Future<Vehicule> creer(Vehicule vehicule) async {
    return vehicule;
  }

  @override
  Future<Vehicule> modifier(Vehicule vehicule) async {
    return vehicule;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String vehiculeId,
  }) async {}
}

class FauxDepotVersement implements DepotVersement {
  @override
  Future<List<Versement>> obtenirTous({
    required String utilisateurId,
  }) async {
    return [
      versement1,
      versement2,
      versementHorsPeriode,
    ];
  }

  @override
  Future<List<Versement>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    return [
      versement1,
      versement2,
      versementHorsPeriode,
    ];
  }

  @override
  Future<Versement?> obtenirParId({
    required String utilisateurId,
    required String versementId,
  }) async {
    return null;
  }

  @override
  Future<Versement> creer({
    required String utilisateurId,
    required Versement versement,
  }) async {
    return versement;
  }

  @override
  Future<Versement> modifier({
    required String utilisateurId,
    required Versement versement,
  }) async {
    return versement;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String versementId,
  }) async {}
}

class FauxDepotDepense implements DepotDepense {
  @override
  Future<List<Depense>> obtenirTous({
    required String utilisateurId,
  }) async {
    return [
      depense,
      depenseHorsPeriode,
    ];
  }

  @override
  Future<List<Depense>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    return [
      depense,
      depenseHorsPeriode,
    ];
  }

  @override
  Future<Depense?> obtenirParId({
    required String utilisateurId,
    required String depenseId,
  }) async {
    return null;
  }

  @override
  Future<Depense> creer({
    required String utilisateurId,
    required Depense depense,
  }) async {
    return depense;
  }

  @override
  Future<Depense> modifier({
    required String utilisateurId,
    required Depense depense,
  }) async {
    return depense;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String depenseId,
  }) async {}
}

class FauxDepotPanne implements DepotPanne {
  @override
  Future<List<Panne>> obtenirTous({
    required String utilisateurId,
  }) async {
    return [
      panne,
      panneHorsPeriode,
    ];
  }

  @override
  Future<List<Panne>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    return [
      panne,
      panneHorsPeriode,
    ];
  }

  @override
  Future<Panne?> obtenirParId({
    required String utilisateurId,
    required String panneId,
  }) async {
    return null;
  }

  @override
  Future<Panne> creer({
    required String utilisateurId,
    required Panne panne,
  }) async {
    return panne;
  }

  @override
  Future<Panne> modifier({
    required String utilisateurId,
    required Panne panne,
  }) async {
    return panne;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String panneId,
  }) async {}
}

class FauxDepotEntretien implements DepotEntretien {
  @override
  Future<List<Entretien>> obtenirTous({
    required String utilisateurId,
  }) async {
    return [entretien];
  }

  @override
  Future<List<Entretien>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    return [entretien];
  }

  @override
  Future<Entretien?> obtenirParId({
    required String utilisateurId,
    required String entretienId,
  }) async {
    return null;
  }

  @override
  Future<Entretien> creer({
    required String utilisateurId,
    required Entretien entretien,
  }) async {
    return entretien;
  }

  @override
  Future<Entretien> modifier({
    required String utilisateurId,
    required Entretien entretien,
  }) async {
    return entretien;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String entretienId,
  }) async {}
}

class FauxDepotDocument implements DepotDocument {
  @override
  Future<List<Document>> obtenirTous({
    required String utilisateurId,
  }) async {
    return [document];
  }

  @override
  Future<List<Document>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    return [document];
  }

  @override
  Future<Document?> obtenirParId({
    required String utilisateurId,
    required String documentId,
  }) async {
    return null;
  }

  @override
  Future<Document> creer({
    required String utilisateurId,
    required Document document,
  }) async {
    return document;
  }

  @override
  Future<Document> modifier({
    required String utilisateurId,
    required Document document,
  }) async {
    return document;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String documentId,
  }) async {}
}

class FauxDepotTypeDocument implements DepotTypeDocument {
  @override
  Future<List<TypeDocument>> obtenirTous({
    required String utilisateurId,
  }) async {
    return [typeDocument];
  }

  @override
  Future<TypeDocument?> obtenirParId({
    required String utilisateurId,
    required String typeDocumentId,
  }) async {
    return typeDocument;
  }

  @override
  Future<TypeDocument> creer({
    required String utilisateurId,
    required TypeDocument typeDocument,
  }) async {
    return typeDocument;
  }

  @override
  Future<TypeDocument> modifier({
    required String utilisateurId,
    required TypeDocument typeDocument,
  }) async {
    return typeDocument;
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String typeDocumentId,
  }) async {}
}

class FauxServiceAlertes implements ServiceAlertes {
  @override
  List<Alerte> genererAlertes({
    required List<Vehicule> vehicules,
    required List<Document> documents,
    required List<TypeDocument> typesDocuments,
    required List<Entretien> entretiens,
    required DateTime dateActuelle,
  }) {
    return [
      Alerte(
        type: TypeAlerte.document,
        vehiculeId: vehiculeId,
        titre: 'Échéance du document proche',
        message: 'Le document Assurance arrive à échéance.',
        niveau: NiveauAlerte.avertissement,
      ),
    ];
  }
}

void main() {
  late ObtenirTableauDeBord obtenirTableauDeBord;

  setUp(() {
    obtenirTableauDeBord = ObtenirTableauDeBord(
      depotVehicule: FauxDepotVehicule(),
      depotVersement: FauxDepotVersement(),
      depotDepense: FauxDepotDepense(),
      depotPanne: FauxDepotPanne(),
      depotEntretien: FauxDepotEntretien(),
      depotDocument: FauxDepotDocument(),
      depotTypeDocument: FauxDepotTypeDocument(),
      serviceAlertes: FauxServiceAlertes(),
    );
  });

  test(
    'calcule les indicateurs financiers de la periode',
    () async {
      final tableauDeBord =
          await obtenirTableauDeBord.executer(
        utilisateurId: utilisateurId,
        debutPeriode: DateTime(2026, 10, 1),
        finPeriode: DateTime(2026, 10, 31),
      );

      expect(
        tableauDeBord.montantVersementsAttendus,
        40000,
      );

      expect(
        tableauDeBord.montantVersementsRecus,
        35000,
      );

      expect(
        tableauDeBord.ecartVersements,
        5000,
      );

      expect(
        tableauDeBord.montantDepenses,
        10000,
      );

      expect(
        tableauDeBord.resultatEstime,
        25000,
      );
    },
  );

  test(
    'ignore les donnees situees hors de la periode',
    () async {
      final tableauDeBord =
          await obtenirTableauDeBord.executer(
        utilisateurId: utilisateurId,
        debutPeriode: DateTime(2026, 10, 1),
        finPeriode: DateTime(2026, 10, 31),
      );

      expect(
        tableauDeBord.montantVersementsAttendus,
        40000,
      );

      expect(
        tableauDeBord.montantDepenses,
        10000,
      );

      expect(
        tableauDeBord.nombrePannes,
        1,
      );
    },
  );

  test(
    'calcule le nombre de vehicules et les performances',
    () async {
      final tableauDeBord =
          await obtenirTableauDeBord.executer(
        utilisateurId: utilisateurId,
        debutPeriode: DateTime(2026, 10, 1),
        finPeriode: DateTime(2026, 10, 31),
      );

      expect(
        tableauDeBord.nombreVehicules,
        1,
      );

      expect(
        tableauDeBord.performancesVehicules.length,
        1,
      );

      final performance =
          tableauDeBord.performancesVehicules.first;

      expect(
        performance.vehicule.id,
        vehiculeId,
      );

      expect(
        performance.versementsAttendus,
        40000,
      );

      expect(
        performance.versementsRecus,
        35000,
      );

      expect(
        performance.ecartVersements,
        5000,
      );

      expect(
        performance.depenses,
        10000,
      );

      expect(
        performance.resultatEstime,
        25000,
      );
    },
  );

  test(
    'compte les entretiens a venir dans les 30 jours',
    () async {
      final tableauDeBord =
          await obtenirTableauDeBord.executer(
        utilisateurId: utilisateurId,
        debutPeriode: DateTime(2026, 10, 1),
        finPeriode: DateTime(2026, 10, 31),
      );

      expect(
        tableauDeBord.nombreEntretiensAVenir,
        1,
      );
    },
  );

  test(
    'compte les alertes actuelles',
    () async {
      final tableauDeBord =
          await obtenirTableauDeBord.executer(
        utilisateurId: utilisateurId,
        debutPeriode: DateTime(2026, 10, 1),
        finPeriode: DateTime(2026, 10, 31),
      );

      expect(
        tableauDeBord.nombreAlertes,
        1,
      );
    },
  );
}