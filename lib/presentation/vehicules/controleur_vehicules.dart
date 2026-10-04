import 'package:flutter/foundation.dart';

import '../../domaine/cas_utilisation/obtenir_vehicules.dart';
import '../../domaine/entites/vehicule.dart';

class ControleurVehicules extends ChangeNotifier {
  final ObtenirVehicules _obtenirVehicules;

  List<Vehicule> _vehicules = [];
  bool _chargement = false;
  String? _messageErreur;

  ControleurVehicules({
    required this._obtenirVehicules,
  });

  List<Vehicule> get vehicules => _vehicules;

  bool get chargement => _chargement;

  String? get messageErreur => _messageErreur;

  Future<void> charger() async {
    _chargement = true;
    _messageErreur = null;

    notifyListeners();

    try {
      _vehicules = await _obtenirVehicules.executer();
    } catch (exception) {
      _messageErreur =
          'Impossible de charger les véhicules.';
    } finally {
      _chargement = false;

      notifyListeners();
    }
  }
}