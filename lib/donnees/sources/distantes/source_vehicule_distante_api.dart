import 'package:dio/dio.dart';

import '../../../domaine/entites/vehicule.dart';
import '../../modeles/vehicule_modele.dart';
import 'source_vehicule_distante.dart';

class SourceVehiculeDistanteApi
    implements SourceVehiculeDistante {
  final Dio _dio;

  SourceVehiculeDistanteApi({
    required this._dio,
  });

  @override
  Future<List<Vehicule>> obtenirTous() async {
    final reponse = await _dio.get('/vehicules');

    final donnees = reponse.data as List<dynamic>;

    return donnees
        .map(
          (element) => VehiculeModele.fromJson(
            element as Map<String, dynamic>,
          ).toEntite(),
        )
        .toList();
  }

  @override
  Future<Vehicule?> obtenirParId(String id) async {
    final reponse = await _dio.get('/vehicules/$id');

    final donnees = reponse.data as Map<String, dynamic>;

    return VehiculeModele.fromJson(donnees).toEntite();
  }

  @override
  Future<void> ajouter(Vehicule vehicule) async {
    await _dio.post(
      '/vehicules',
      data: VehiculeModele.fromEntite(vehicule).toJson(),
    );
  }

  @override
  Future<void> modifier(Vehicule vehicule) async {
    await _dio.put(
      '/vehicules/${vehicule.id}',
      data: VehiculeModele.fromEntite(vehicule).toJson(),
    );
  }

  @override
  Future<void> supprimer(String id) async {
    await _dio.delete('/vehicules/$id');
  }
}