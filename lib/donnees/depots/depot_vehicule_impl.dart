import '../../domaine/depots/depot_vehicule.dart';
import '../../domaine/entites/resultat_vehicules.dart';
import '../../domaine/entites/vehicule.dart';
import '../modeles/vehicule_modele.dart';
import '../sources/distantes/source_vehicule_distante.dart';
import '../sources/locales/source_vehicule_locale.dart';

class DepotVehiculeImpl implements DepotVehicule {
  final SourceVehiculeDistante sourceDistante;
  final SourceVehiculeLocale sourceLocale;

  DepotVehiculeImpl({
    required this.sourceDistante,
    required this.sourceLocale,
  });

  @override
  Future<ResultatVehicules> obtenirTous() async {
    try {
      final vehicules = await sourceDistante.obtenirTous();

      final modeles = vehicules
          .map(
            VehiculeModele.fromEntite,
          )
          .toList();

      await sourceLocale.enregistrerTous(
        modeles,
      );

      return ResultatVehicules(
        vehicules: vehicules,
        sourceLocale: false,
      );
    } catch (_) {
      final vehicules = await sourceLocale.obtenirTous();

      if (vehicules.isEmpty) {
        rethrow;
      }

      return ResultatVehicules(
        vehicules: vehicules,
        sourceLocale: true,
      );
    }
  }

  @override
  Future<Vehicule?> obtenirParId(String id) async {
    try {
      final vehicule =
          await sourceDistante.obtenirParId(id);

      if (vehicule != null) {
        await sourceLocale.enregistrer(
          VehiculeModele.fromEntite(vehicule),
        );
      }

      return vehicule;
    } catch (_) {
      return sourceLocale.obtenirParId(id);
    }
  }

  @override
  Future<Vehicule> ajouter(
    Vehicule vehicule,
  ) async {
    final vehiculeCree =
        await sourceDistante.ajouter(vehicule);

    await sourceLocale.enregistrer(
      VehiculeModele.fromEntite(
        vehiculeCree,
      ),
    );

    return vehiculeCree;
  }

  @override
  Future<void> modifier(
    Vehicule vehicule,
  ) async {
    await sourceDistante.modifier(vehicule);

    await sourceLocale.enregistrer(
      VehiculeModele.fromEntite(vehicule),
    );
  }

  @override
  Future<void> supprimer(String id) async {
    await sourceDistante.supprimer(id);

    await sourceLocale.supprimer(id);
  }
}