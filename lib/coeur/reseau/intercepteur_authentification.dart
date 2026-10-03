import 'package:dio/dio.dart';

import '../stockage/stockage_session.dart';

class IntercepteurAuthentification extends Interceptor {
  final StockageSession _stockageSession;

  IntercepteurAuthentification({
    required this._stockageSession,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final jeton = await _stockageSession.obtenirJeton();

    if (jeton != null && jeton.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $jeton';
    }

    handler.next(options);
  }
}