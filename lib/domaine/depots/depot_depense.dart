import '../entites/depense.dart';

abstract class DepotDepense {
  Future<List<Depense>> obtenirTous();

  Future<Depense> creer({
    required String vehiculeId,
    required String categorieId,
    required DateTime date,
    required double montant,
    String? description,
  });
}