import '../../../domaine/entites/vehicule.dart';
import 'source_vehicule_distante.dart';

class SourceVehiculeDistanteMemoire
    implements SourceVehiculeDistante {
  final List<Vehicule> _vehicules = [];

  @override
  Future<List<Vehicule>> obtenirTous() async {
    return List.unmodifiable(_vehicules);
  }

  @override
  Future<Vehicule?> obtenirParId(String id) async {
    for (final vehicule in _vehicules) {
      if (vehicule.id == id) {
        return vehicule;
      }
    }

    return null;
  }

  @override
  Future<Vehicule> ajouter(
    Vehicule vehicule,
  ) async {
    _vehicules.add(vehicule);

    return vehicule;
  }

  @override
  Future<void> modifier(
    Vehicule vehicule,
  ) async {
    final index = _vehicules.indexWhere(
      (element) => element.id == vehicule.id,
    );

    if (index == -1) {
      return;
    }

    _vehicules[index] = vehicule;
  }

  @override
  Future<void> supprimer(String id) async {
    _vehicules.removeWhere(
      (vehicule) => vehicule.id == id,
    );
  }
}