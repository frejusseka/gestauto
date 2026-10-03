import 'dart:io';

import 'package:dio/dio.dart';

import 'intercepteur_erreur.dart';

class ConfigurationDio {
  static String get _adresseApi {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }

    return 'http://localhost:8080';
  }

  static Dio creer() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _adresseApi,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      IntercepteurErreur(),
    );

    return dio;
  }
}