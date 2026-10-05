import '../entites/utilisateur.dart';

abstract class DepotUtilisateur {
  Future<Utilisateur?> obtenirParEmail(String email);

  Future<Utilisateur> creer(Utilisateur utilisateur);
}