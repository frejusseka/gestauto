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
  bool _sourceLocale = false;
  String? _messageErreur;

  ControleurVehicules({
    required ObtenirVehicules obtenirVehicules,
    required AjouterVehicule ajouterVehicule,
  })  : _obtenirVehicules = obtenirVehicules,
        _ajouterVehicule = ajouterVehicule;

  List<Vehicule> get vehicules => _vehicules;

  bool get chargement => _chargement;

  bool get creationEnCours => _creationEnCours;

  bool get sourceLocale => _sourceLocale;

  String? get messageErreur => _messageErreur;

  Future<void> charger() async {
    _chargement = true;
    _messageErreur = null;

    notifyListeners();

    try {
      final resultat =
          await _obtenirVehicules.executer();

      _vehicules = resultat.vehicules;
      _sourceLocale = resultat.sourceLocale;
    } catch (_) {
      _messageErreur =
          'Impossible de charger les véhicules. '
          'Vérifiez votre connexion puis réessayez.';
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

      _sourceLocale = false;

      return true;
    } catch (_) {
      _messageErreur =
          'Impossible d’ajouter le véhicule. '
          'Vérifiez votre connexion puis réessayez.';

      return false;
    } finally {
      _creationEnCours = false;

      notifyListeners();
    }
  }
}