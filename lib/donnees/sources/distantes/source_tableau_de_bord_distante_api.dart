import 'package:dio/dio.dart';

import '../../../domaine/entites/tableau_de_bord.dart';
import '../../modeles/tableau_de_bord_modele.dart';
import 'source_tableau_de_bord_distante.dart';

class SourceTableauDeBordDistanteApi
    implements SourceTableauDeBordDistante {
  final Dio _dio;

  SourceTableauDeBordDistanteApi({
    required this._dio,
  });

  @override
  Future<TableauDeBord> obtenir() async {
    final reponse = await _dio.get(
      '/protegee/tableau_de_bord',
    );

    final donnees =
        reponse.data as Map<String, dynamic>;

    return TableauDeBordModele.fromJson(
      donnees,
    ).toEntite();
  }
}