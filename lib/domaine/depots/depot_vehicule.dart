import '../entites/resultat_vehicules.dart';
import '../entites/vehicule.dart';

abstract class DepotVehicule {
  Future<ResultatVehicules> obtenirTous();

  Future<Vehicule?> obtenirParId(String id);

  Future<Vehicule> ajouter(Vehicule vehicule);

  Future<void> modifier(Vehicule vehicule);

  Future<void> supprimer(String id);
}