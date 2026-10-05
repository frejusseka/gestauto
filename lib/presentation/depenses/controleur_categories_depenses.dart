import 'package:flutter/foundation.dart';

import '../../domaine/cas_utilisation/creer_categorie_depense.dart';
import '../../domaine/cas_utilisation/obtenir_categories_depense.dart';
import '../../domaine/entites/categorie_depense.dart';

class ControleurCategoriesDepenses
    extends ChangeNotifier {
  final ObtenirCategoriesDepense
      _obtenirCategoriesDepense;
  final CreerCategorieDepense
      _creerCategorieDepense;

  List<CategorieDepense> _categories = [];
  bool _chargement = false;
  bool _creationEnCours = false;
  String? _messageErreur;

  ControleurCategoriesDepenses({
    required this._obtenirCategoriesDepense,
    required this._creerCategorieDepense,
  });

  List<CategorieDepense> get categories =>
      _categories;

  bool get chargement => _chargement;

  bool get creationEnCours =>
      _creationEnCours;

  String? get messageErreur => _messageErreur;

  Future<void> charger() async {
    _chargement = true;
    _messageErreur = null;

    notifyListeners();

    try {
      _categories =
          await _obtenirCategoriesDepense.executer();
    } catch (exception) {
      _messageErreur =
          'Impossible de charger les catégories.';
    } finally {
      _chargement = false;

      notifyListeners();
    }
  }

  Future<bool> creer({
    required String nom,
  }) async {
    _creationEnCours = true;
    _messageErreur = null;

    notifyListeners();

    try {
      final categorie =
          await _creerCategorieDepense.executer(
        nom: nom,
      );

      _categories = [
        ..._categories,
        categorie,
      ];

      return true;
    } catch (exception) {
      _messageErreur =
          'Impossible de créer la catégorie.';

      return false;
    } finally {
      _creationEnCours = false;

      notifyListeners();
    }
  }
}