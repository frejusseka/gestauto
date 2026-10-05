import '../entites/vehicule.dart';

abstract class DepotVehicule {
  Future<List<Vehicule>> obtenirTous(String utilisateurId);

  Future<Vehicule?> obtenirParId({
    required String utilisateurId,
    required String vehiculeId,
  });

  Future<Vehicule> creer(Vehicule vehicule);

  Future<Vehicule> modifier(Vehicule vehicule);

  Future<void> supprimer({
    required String utilisateurId,
    required String vehiculeId,
  });
}