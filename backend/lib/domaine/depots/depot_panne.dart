import '../entites/panne.dart';

abstract class DepotPanne {
  Future<List<Panne>> obtenirTous({
    required String utilisateurId,
  });

  Future<List<Panne>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  });

  Future<Panne?> obtenirParId({
    required String utilisateurId,
    required String panneId,
  });

  Future<Panne> creer({
    required String utilisateurId,
    required Panne panne,
  });

  Future<Panne> modifier({
    required String utilisateurId,
    required Panne panne,
  });

  Future<void> supprimer({
    required String utilisateurId,
    required String panneId,
  });
}