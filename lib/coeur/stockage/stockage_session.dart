import 'package:shared_preferences/shared_preferences.dart';

class StockageSession {
  static const String _cleJeton = 'jeton_authentification';

  Future<void> enregistrerJeton(String jeton) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _cleJeton,
      jeton,
    );
  }

  Future<String?> obtenirJeton() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(_cleJeton);
  }

  Future<void> supprimerJeton() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_cleJeton);
  }
}