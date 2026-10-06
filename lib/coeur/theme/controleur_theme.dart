import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControleurTheme extends ChangeNotifier {
  static const String _cleModeSombre = 'mode_sombre';

  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  bool get modeSombre => _mode == ThemeMode.dark;

  Future<void> charger() async {
    final preferences = await SharedPreferences.getInstance();

    final modeSombreEnregistre =
        preferences.getBool(_cleModeSombre) ?? false;

    _mode = modeSombreEnregistre
        ? ThemeMode.dark
        : ThemeMode.light;

    notifyListeners();
  }

  Future<void> changerMode(bool modeSombre) async {
    _mode = modeSombre
        ? ThemeMode.dark
        : ThemeMode.light;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      _cleModeSombre,
      modeSombre,
    );

    notifyListeners();
  }
}