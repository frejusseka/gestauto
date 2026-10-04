import '../../domaine/depots/depot_versement.dart';
import '../../domaine/entites/versement.dart';
import '../sources/distantes/source_versement_distante_api.dart';

class DepotVersementImpl
    implements DepotVersement {
  final SourceVersementDistanteApi _sourceDistante;

  DepotVersementImpl({
    required this._sourceDistante,
  });

  @override
  Future<List<Versement>> obtenirTous() {
    return _sourceDistante.obtenirTous();
  }

  @override
  Future<Versement> creer({
    required String vehiculeId,
    required DateTime date,
    required double montantAttendu,
    required double montantVerse,
  }) {
    return _sourceDistante.creer(
      vehiculeId: vehiculeId,
      date: date,
      montantAttendu: montantAttendu,
      montantVerse: montantVerse,
    );
  }
}