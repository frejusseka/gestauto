import 'package:flutter/foundation.dart';

import '../../domaine/cas_utilisation/obtenir_tableau_de_bord.dart';
import '../../domaine/entites/tableau_de_bord.dart';

class ControleurTableauDeBord extends ChangeNotifier {
  final ObtenirTableauDeBord _obtenirTableauDeBord;

  TableauDeBord? _tableauDeBord;
  bool _chargement = false;
  String? _messageErreur;

  ControleurTableauDeBord({
    required this._obtenirTableauDeBord,
  });

  TableauDeBord? get tableauDeBord => _tableauDeBord;

  bool get chargement => _chargement;

  String? get messageErreur => _messageErreur;

  Future<void> charger() async {
    _chargement = true;
    _messageErreur = null;

    notifyListeners();

    try {
      _tableauDeBord =
          await _obtenirTableauDeBord.executer();
    } catch (exception) {
      _messageErreur =
          'Impossible de charger le tableau de bord.';
    } finally {
      _chargement = false;

      notifyListeners();
    }
  }
}