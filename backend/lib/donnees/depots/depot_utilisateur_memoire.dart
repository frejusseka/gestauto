import '../../domaine/depots/depot_utilisateur.dart';
import '../../domaine/entites/utilisateur.dart';

class DepotUtilisateurMemoire implements DepotUtilisateur {
  final List<Utilisateur> _utilisateurs = [];

  @override
  Future<Utilisateur?> obtenirParEmail(String email) async {
    for (final utilisateur in _utilisateurs) {
      if (utilisateur.email == email) {
        return utilisateur;
      }
    }

    return null;
  }

  @override
  Future<Utilisateur> creer(Utilisateur utilisateur) async {
    _utilisateurs.add(utilisateur);

    return utilisateur;
  }
}