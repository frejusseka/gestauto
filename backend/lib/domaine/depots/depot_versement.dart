import '../entites/versement.dart';

abstract class DepotVersement {
  Future<List<Versement>> obtenirTous({
    required String utilisateurId,
  });

  Future<List<Versement>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  });

  Future<Versement?> obtenirParId({
    required String utilisateurId,
    required String versementId,
  });

  Future<Versement> creer({
    required String utilisateurId,
    required Versement versement,
  });

  Future<Versement> modifier({
    required String utilisateurId,
    required Versement versement,
  });

  Future<void> supprimer({
    required String utilisateurId,
    required String versementId,
  });
}