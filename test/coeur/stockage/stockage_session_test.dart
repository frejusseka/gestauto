import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gestauto/coeur/stockage/stockage_session.dart';

void main() {
  late StockageSession stockage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    stockage = StockageSession();
  });

  test(
    'enregistrerJeton puis obtenirJeton retourne le jeton',
    () async {
      await stockage.enregistrerJeton('jeton-test');

      final jeton = await stockage.obtenirJeton();

      expect(jeton, 'jeton-test');
    },
  );

  test(
    'obtenirJeton retourne null lorsqu aucun jeton existe',
    () async {
      final jeton = await stockage.obtenirJeton();

      expect(jeton, isNull);
    },
  );

  test(
    'supprimerJeton supprime le jeton enregistré',
    () async {
      await stockage.enregistrerJeton('jeton-test');

      await stockage.supprimerJeton();

      final jeton = await stockage.obtenirJeton();

      expect(jeton, isNull);
    },
  );
}