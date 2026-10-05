import 'package:flutter/foundation.dart';

import '../../domaine/cas_utilisation/creer_depense.dart';
import '../../domaine/cas_utilisation/obtenir_depenses.dart';
import '../../domaine/entites/depense.dart';

class ControleurDepenses extends ChangeNotifier {
  final ObtenirDepenses _obtenirDepenses;
  final CreerDepense _creerDepense;

  List<Depense> _depenses = [];
  bool _chargement = false;
  bool _creationEnCours = false;
  String? _messageErreur;

  ControleurDepenses({
    required this._obtenirDepenses,
    required this._creerDepense,
  });

  List<Depense> get depenses => _depenses;

  bool get chargement => _chargement;

  bool get creationEnCours => _creationEnCours;

  String? get messageErreur => _messageErreur;

  Future<void> charger() async {
    _chargement = true;
    _messageErreur = null;

    notifyListeners();

    try {
      _depenses =
          await _obtenirDepenses.executer();
    } catch (exception) {
      _messageErreur =
          'Impossible de charger les dépenses.';
    } finally {
      _chargement = false;

      notifyListeners();
    }
  }

  Future<bool> creer({
    required String vehiculeId,
    required String categorieId,
    required DateTime date,
    required double montant,
    String? description,
  }) async {
    _creationEnCours = true;
    _messageErreur = null;

    notifyListeners();

    try {
      final depense =
          await _creerDepense.executer(
        vehiculeId: vehiculeId,
        categorieId: categorieId,
        date: date,
        montant: montant,
        description: description,
      );

      _depenses = [
        depense,
        ..._depenses,
      ];

      return true;
    } catch (exception) {
      _messageErreur =
          'Impossible de créer la dépense.';

      return false;
    } finally {
      _creationEnCours = false;

      notifyListeners();
    }
  }
}