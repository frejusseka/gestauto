import '../entites/panne.dart';

abstract class DepotPanne {
  Future<List<Panne>> obtenirTous();

  Future<Panne> creer({
    required Panne panne,
  });

  Future<Panne> modifier({
    required Panne panne,
  });

  Future<void> supprimer({
    required String panneId,
  });
}