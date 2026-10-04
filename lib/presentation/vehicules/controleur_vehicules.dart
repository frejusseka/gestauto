import 'package:flutter/foundation.dart';

import '../../domaine/cas_utilisation/ajouter_vehicule.dart';
import '../../domaine/cas_utilisation/obtenir_vehicules.dart';
import '../../domaine/entites/vehicule.dart';

class ControleurVehicules extends ChangeNotifier {
  final ObtenirVehicules _obtenirVehicules;
  final AjouterVehicule _ajouterVehicule;

  List<Vehicule> _vehicules = [];
  bool _chargement = false;
  bool _creationEnCours = false;
  String? _messageErreur;

  ControleurVehicules({
    required this._obtenirVehicules,
    required this._ajouterVehicule,
  });

  List<Vehicule> get vehicules => _vehicules;

  bool get chargement => _chargement;

  bool get creationEnCours => _creationEnCours;

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

  Future<bool> ajouter(Vehicule vehicule) async {
    _creationEnCours = true;
    _messageErreur = null;

    notifyListeners();

    try {
      final vehiculeCree =
          await _ajouterVehicule.executer(vehicule);

      _vehicules = [
        vehiculeCree,
        ..._vehicules,
      ];

      return true;
    } catch (exception) {
      _messageErreur =
          'Impossible d’ajouter le véhicule.';

      return false;
    } finally {
      _creationEnCours = false;

      notifyListeners();
    }
  }
}