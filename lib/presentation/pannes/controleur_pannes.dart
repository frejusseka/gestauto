import 'package:flutter/foundation.dart';

import '../../domaine/cas_utilisation/creer_panne.dart';
import '../../domaine/cas_utilisation/modifier_panne.dart';
import '../../domaine/cas_utilisation/obtenir_pannes.dart';
import '../../domaine/cas_utilisation/supprimer_panne.dart';
import '../../domaine/entites/panne.dart';

class ControleurPannes extends ChangeNotifier {
  final ObtenirPannes _obtenirPannes;
  final CreerPanne _creerPanne;
  final ModifierPanne _modifierPanne;
  final SupprimerPanne _supprimerPanne;

  ControleurPannes({
    required this._obtenirPannes,
    required this._creerPanne,
    required this._modifierPanne,
    required this._supprimerPanne,
  });

  List<Panne> _pannes = [];

  List<Panne> get pannes => _pannes;

  bool _chargement = false;

  bool get chargement => _chargement;

  String? _erreur;

  String? get erreur => _erreur;

  Future<void> chargerPannes() async {
    _chargement = true;
    _erreur = null;
    notifyListeners();

    try {
      _pannes = await _obtenirPannes.executer();
    } catch (erreur) {
      _erreur = erreur.toString();
    } finally {
      _chargement = false;
      notifyListeners();
    }
  }

  Future<bool> creer({
    required Panne panne,
  }) async {
    _erreur = null;

    try {
      final panneCreee =
          await _creerPanne.executer(
        panne: panne,
      );

      _pannes = [
        panneCreee,
        ..._pannes,
      ];

      notifyListeners();

      return true;
    } catch (erreur) {
      _erreur = erreur.toString();
      notifyListeners();

      return false;
    }
  }

  Future<bool> modifier({
    required Panne panne,
  }) async {
    _erreur = null;

    try {
      final panneModifiee =
          await _modifierPanne.executer(
        panne: panne,
      );

      final index = _pannes.indexWhere(
        (element) => element.id == panne.id,
      );

      if (index != -1) {
        _pannes[index] = panneModifiee;
      }

      notifyListeners();

      return true;
    } catch (erreur) {
      _erreur = erreur.toString();
      notifyListeners();

      return false;
    }
  }

  Future<bool> supprimer({
    required String panneId,
  }) async {
    _erreur = null;

    try {
      await _supprimerPanne.executer(
        panneId: panneId,
      );

      _pannes.removeWhere(
        (panne) => panne.id == panneId,
      );

      notifyListeners();

      return true;
    } catch (erreur) {
      _erreur = erreur.toString();
      notifyListeners();

      return false;
    }
  }
}