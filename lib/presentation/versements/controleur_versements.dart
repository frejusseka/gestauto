import 'package:flutter/foundation.dart';

import '../../domaine/cas_utilisation/creer_versement.dart';
import '../../domaine/cas_utilisation/obtenir_versements.dart';
import '../../domaine/entites/versement.dart';

class ControleurVersements extends ChangeNotifier {
  final ObtenirVersements _obtenirVersements;
  final CreerVersement _creerVersement;

  List<Versement> _versements = [];
  bool _chargement = false;
  bool _creationEnCours = false;
  String? _messageErreur;

  ControleurVersements({
    required this._obtenirVersements,
    required this._creerVersement,
  });

  List<Versement> get versements => _versements;

  bool get chargement => _chargement;

  bool get creationEnCours => _creationEnCours;

  String? get messageErreur => _messageErreur;

  Future<void> charger() async {
    _chargement = true;
    _messageErreur = null;

    notifyListeners();

    try {
      _versements =
          await _obtenirVersements.executer();
    } catch (exception) {
      _messageErreur =
          'Impossible de charger les versements.';
    } finally {
      _chargement = false;

      notifyListeners();
    }
  }

  Future<bool> creer({
    required String vehiculeId,
    required DateTime date,
    required double montantAttendu,
    required double montantVerse,
  }) async {
    _creationEnCours = true;
    _messageErreur = null;

    notifyListeners();

    try {
      final versement =
          await _creerVersement.executer(
        vehiculeId: vehiculeId,
        date: date,
        montantAttendu: montantAttendu,
        montantVerse: montantVerse,
      );

      _versements = [
        versement,
        ..._versements,
      ];

      return true;
    } catch (exception) {
      _messageErreur =
          'Impossible de créer le versement.';

      return false;
    } finally {
      _creationEnCours = false;

      notifyListeners();
    }
  }
}