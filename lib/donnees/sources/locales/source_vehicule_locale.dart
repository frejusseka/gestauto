import 'package:hive_flutter/hive_flutter.dart';

import '../../modeles/vehicule_modele.dart';

class SourceVehiculeLocale {
  static const String _nomBoite = 'vehicules';

  Future<Box<dynamic>> _ouvrirBoite() async {
    if (Hive.isBoxOpen(_nomBoite)) {
      return Hive.box<dynamic>(_nomBoite);
    }

    return Hive.openBox<dynamic>(_nomBoite);
  }

  Future<void> enregistrerTous(
    List<VehiculeModele> vehicules,
  ) async {
    final boite = await _ouvrirBoite();

    await boite.clear();

    for (final vehicule in vehicules) {
      await boite.put(
        vehicule.id,
        vehicule.toJson(),
      );
    }
  }

  Future<List<VehiculeModele>> obtenirTous() async {
    final boite = await _ouvrirBoite();

    return boite.values
        .map(
          (donnees) => VehiculeModele.fromJson(
            Map<String, dynamic>.from(
              donnees as Map,
            ),
          ),
        )
        .toList();
  }

  Future<VehiculeModele?> obtenirParId(
    String id,
  ) async {
    final boite = await _ouvrirBoite();

    final donnees = boite.get(id);

    if (donnees == null) {
      return null;
    }

    return VehiculeModele.fromJson(
      Map<String, dynamic>.from(
        donnees as Map,
      ),
    );
  }

  Future<void> enregistrer(
    VehiculeModele vehicule,
  ) async {
    final boite = await _ouvrirBoite();

    await boite.put(
      vehicule.id,
      vehicule.toJson(),
    );
  }

  Future<void> supprimer(String id) async {
    final boite = await _ouvrirBoite();

    await boite.delete(id);
  }

  Future<void> vider() async {
    final boite = await _ouvrirBoite();

    await boite.clear();
  }
}