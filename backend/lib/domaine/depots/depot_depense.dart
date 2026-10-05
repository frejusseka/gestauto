import '../entites/depense.dart';

abstract class DepotDepense {
  Future<List<Depense>> obtenirTous({
    required String utilisateurId,
  });

  Future<List<Depense>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  });

  Future<Depense?> obtenirParId({
    required String utilisateurId,
    required String depenseId,
  });

  Future<Depense> creer({
    required String utilisateurId,
    required Depense depense,
  });

  Future<Depense> modifier({
    required String utilisateurId,
    required Depense depense,
  });

  Future<void> supprimer({
    required String utilisateurId,
    required String depenseId,
  });
}