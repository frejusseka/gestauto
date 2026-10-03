import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gestauto/coeur/reseau/intercepteur_authentification.dart';
import 'package:gestauto/coeur/stockage/stockage_session.dart';

void main() {
  late StockageSession stockageSession;
  late IntercepteurAuthentification intercepteur;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    stockageSession = StockageSession();

    intercepteur = IntercepteurAuthentification(
      stockageSession: stockageSession,
    );
  });

  test(
    'ajoute le JWT dans le header Authorization',
    () async {
      await stockageSession.enregistrerJeton(
        'jeton-test',
      );

      final options = RequestOptions(
        path: '/vehicules',
      );

      final handler = RequestInterceptorHandler();

      await intercepteur.onRequest(
        options,
        handler,
      );

      expect(
        options.headers['Authorization'],
        'Bearer jeton-test',
      );
    },
  );

  test(
    'n ajoute pas Authorization lorsqu aucun JWT existe',
    () async {
      final options = RequestOptions(
        path: '/vehicules',
      );

      final handler = RequestInterceptorHandler();

      await intercepteur.onRequest(
        options,
        handler,
      );

      expect(
        options.headers.containsKey('Authorization'),
        isFalse,
      );
    },
  );
}