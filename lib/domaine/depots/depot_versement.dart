import '../entites/versement.dart';

abstract class DepotVersement {
  Future<List<Versement>> obtenirTous();

  Future<Versement> creer({
    required String vehiculeId,
    required DateTime date,
    required double montantAttendu,
    required double montantVerse,
  });
}