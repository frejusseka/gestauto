import '../../domaine/depots/depot_vehicule.dart';
import '../../domaine/entites/vehicule.dart';
import '../sources/distantes/source_vehicule_distante.dart';

class DepotVehiculeImpl implements DepotVehicule {
  final SourceVehiculeDistante sourceDistante;

  DepotVehiculeImpl({
    required this.sourceDistante,
  });

  @override
  Future<List<Vehicule>> obtenirTous() {
    return sourceDistante.obtenirTous();
  }

  @override
  Future<Vehicule?> obtenirParId(String id) {
    return sourceDistante.obtenirParId(id);
  }

  @override
  Future<void> ajouter(Vehicule vehicule) {
    return sourceDistante.ajouter(vehicule);
  }

  @override
  Future<void> modifier(Vehicule vehicule) {
    return sourceDistante.modifier(vehicule);
  }

  @override
  Future<void> supprimer(String id) {
    return sourceDistante.supprimer(id);
  }
}