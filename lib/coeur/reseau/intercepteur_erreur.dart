import 'package:dio/dio.dart';

import '../erreurs/exception_reseau.dart';

class IntercepteurErreur extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final exception = _convertirErreur(err);

    final nouvelleErreur = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: exception,
      message: exception.message,
    );

    handler.next(nouvelleErreur);
  }

  ExceptionReseau _convertirErreur(DioException erreur) {
    if (erreur.type == DioExceptionType.connectionError) {
      return ExceptionReseau(
        message: 'Impossible de contacter le serveur.',
      );
    }

    if (erreur.type == DioExceptionType.connectionTimeout ||
        erreur.type == DioExceptionType.receiveTimeout ||
        erreur.type == DioExceptionType.sendTimeout) {
      return ExceptionReseau(
        message: 'Le délai de connexion au serveur est dépassé.',
      );
    }

    final codeStatut = erreur.response?.statusCode;

    if (codeStatut != null) {
      return ExceptionReseau(
        message: _messageSelonCode(codeStatut),
        codeStatut: codeStatut,
      );
    }

    return ExceptionReseau(
      message: 'Une erreur réseau est survenue.',
    );
  }

  String _messageSelonCode(int codeStatut) {
    switch (codeStatut) {
      case 400:
        return 'La requête envoyée est incorrecte.';
      case 401:
        return 'Vous devez être authentifié.';
      case 403:
        return 'Vous n’avez pas l’autorisation d’effectuer cette action.';
      case 404:
        return 'La ressource demandée est introuvable.';
      case 500:
        return 'Une erreur est survenue sur le serveur.';
      case 502:
      case 503:
      case 504:
        return 'Le serveur est temporairement indisponible.';
      default:
        return 'Le serveur a retourné une erreur.';
    }
  }
}