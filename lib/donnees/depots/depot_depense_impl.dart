import '../../domaine/depots/depot_depense.dart';
import '../../domaine/entites/depense.dart';
import '../sources/distantes/source_depense_distante_api.dart';

class DepotDepenseImpl implements DepotDepense {
  final SourceDepenseDistanteApi _sourceDistante;

  DepotDepenseImpl({
    required this._sourceDistante,
  });

  @override
  Future<List<Depense>> obtenirTous() {
    return _sourceDistante.obtenirTous();
  }

  @override
  Future<Depense> creer({
    required String vehiculeId,
    required String categorieId,
    required DateTime date,
    required double montant,
    String? description,
  }) {
    return _sourceDistante.creer(
      vehiculeId: vehiculeId,
      categorieId: categorieId,
      date: date,
      montant: montant,
      description: description,
    );
  }
}