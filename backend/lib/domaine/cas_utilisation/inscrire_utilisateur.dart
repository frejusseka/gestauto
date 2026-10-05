import 'package:uuid/uuid.dart';

import '../../coeur/erreurs/email_deja_utilise_exception.dart';
import '../depots/depot_categorie_depense.dart';
import '../depots/depot_utilisateur.dart';
import '../entites/categorie_depense.dart';
import '../entites/utilisateur.dart';
import '../services/service_mot_de_passe.dart';

class InscrireUtilisateur {
  final DepotUtilisateur _depot;
  final DepotCategorieDepense _depotCategorieDepense;
  final ServiceMotDePasse _serviceMotDePasse;

  InscrireUtilisateur({
    required DepotUtilisateur depot,
    required DepotCategorieDepense depotCategorieDepense,
    required ServiceMotDePasse serviceMotDePasse,
  })  : _depot = depot,
        _depotCategorieDepense = depotCategorieDepense,
        _serviceMotDePasse = serviceMotDePasse;

  Future<Utilisateur> executer({
    required String id,
    required String nom,
    required String email,
    required String motDePasse,
  }) async {
    final utilisateurExistant =
        await _depot.obtenirParEmail(email);

    if (utilisateurExistant != null) {
      throw EmailDejaUtiliseException();
    }

    final motDePasseHache =
        _serviceMotDePasse.hacher(motDePasse);

    final utilisateur = Utilisateur(
      id: id,
      nom: nom,
      email: email,
      motDePasse: motDePasseHache,
    );

    final utilisateurCree =
        await _depot.creer(utilisateur);

    await _creerCategoriesParDefaut(
      utilisateurId: utilisateur.id,
    );

    return utilisateurCree;
  }

  Future<void> _creerCategoriesParDefaut({
    required String utilisateurId,
  }) async {
    const categories = [
      'Carburant',
      'Entretien',
      'Réparation',
      'Assurance',
      'Patente',
    ];

    const uuid = Uuid();

    for (final nom in categories) {
      await _depotCategorieDepense.creer(
        categorie: CategorieDepense(
          id: uuid.v4(),
          utilisateurId: utilisateurId,
          nom: nom,
        ),
      );
    }
  }
}