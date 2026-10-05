import '../../domaine/depots/depot_panne.dart';
import '../../domaine/entites/panne.dart';
import '../modeles/panne_modele.dart';
import '../sources/distantes/source_panne_distante_api.dart';

class DepotPanneImpl implements DepotPanne {
  final SourcePanneDistanteApi _sourceDistante;

  DepotPanneImpl({
    required this._sourceDistante,
  });

  @override
  Future<List<Panne>> obtenirTous() async {
    return _sourceDistante.obtenirTous();
  }

  @override
  Future<Panne> creer({
    required Panne panne,
  }) async {
    final modele = PanneModele(
      id: panne.id,
      vehiculeId: panne.vehiculeId,
      date: panne.date,
      description: panne.description,
      gravite: panne.gravite,
      resolue: panne.resolue,
      dateResolution: panne.dateResolution,
    );

    return _sourceDistante.creer(
      panne: modele,
    );
  }

  @override
  Future<Panne> modifier({
    required Panne panne,
  }) async {
    final modele = PanneModele(
      id: panne.id,
      vehiculeId: panne.vehiculeId,
      date: panne.date,
      description: panne.description,
      gravite: panne.gravite,
      resolue: panne.resolue,
      dateResolution: panne.dateResolution,
    );

    return _sourceDistante.modifier(
      panne: modele,
    );
  }

  @override
  Future<void> supprimer({
    required String panneId,
  }) async {
    await _sourceDistante.supprimer(
      panneId: panneId,
    );
  }
}