import '../entites/entretien.dart';

abstract class DepotEntretien {
  Future<List<Entretien>> obtenirTous({
    required String utilisateurId,
  });

  Future<List<Entretien>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  });

  Future<Entretien?> obtenirParId({
    required String utilisateurId,
    required String entretienId,
  });

  Future<Entretien> creer({
    required String utilisateurId,
    required Entretien entretien,
  });

  Future<Entretien> modifier({
    required String utilisateurId,
    required Entretien entretien,
  });

  Future<void> supprimer({
    required String utilisateurId,
    required String entretienId,
  });
}