import '../entites/vehicule.dart';

abstract class DepotVehicule {
  Future<List<Vehicule>> obtenirTous();

  Future<Vehicule?> obtenirParId(String id);

  Future<void> ajouter(Vehicule vehicule);

  Future<void> modifier(Vehicule vehicule);

  Future<void> supprimer(String id);
}