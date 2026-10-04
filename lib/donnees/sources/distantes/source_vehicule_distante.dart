import '../../../domaine/entites/vehicule.dart';

abstract class SourceVehiculeDistante {
  Future<List<Vehicule>> obtenirTous();

  Future<Vehicule?> obtenirParId(String id);

  Future<Vehicule> ajouter(Vehicule vehicule);

  Future<void> modifier(Vehicule vehicule);

  Future<void> supprimer(String id);
}