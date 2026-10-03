import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestauto/coeur/erreurs/exception_reseau.dart';
import 'package:gestauto/coeur/reseau/intercepteur_erreur.dart';

class GestionnaireErreurTest extends ErrorInterceptorHandler {
  DioException? erreur;

  @override
  void next(DioException erreur) {
    this.erreur = erreur;
  }
}

void main() {
  test('doit convertir une erreur 401 en ExceptionReseau', () {
    final intercepteur = IntercepteurErreur();

    final erreur = DioException(
      requestOptions: RequestOptions(
        path: '/test',
      ),
      response: Response(
        requestOptions: RequestOptions(
          path: '/test',
        ),
        statusCode: 401,
      ),
      type: DioExceptionType.badResponse,
    );

    final gestionnaire = GestionnaireErreurTest();

    intercepteur.onError(
      erreur,
      gestionnaire,
    );

    expect(gestionnaire.erreur, isNotNull);
    expect(
      gestionnaire.erreur!.error,
      isA<ExceptionReseau>(),
    );

    final exception =
        gestionnaire.erreur!.error as ExceptionReseau;

    expect(exception.codeStatut, 401);
    expect(
      exception.message,
      'Vous devez être authentifié.',
    );
  });

  test(
    'doit convertir une erreur de connexion en ExceptionReseau',
    () {
      final intercepteur = IntercepteurErreur();

      final erreur = DioException(
        requestOptions: RequestOptions(
          path: '/test',
        ),
        type: DioExceptionType.connectionError,
      );

      final gestionnaire = GestionnaireErreurTest();

      intercepteur.onError(
        erreur,
        gestionnaire,
      );

      expect(gestionnaire.erreur, isNotNull);
      expect(
        gestionnaire.erreur!.error,
        isA<ExceptionReseau>(),
      );

      final exception =
          gestionnaire.erreur!.error as ExceptionReseau;

      expect(
        exception.message,
        'Impossible de contacter le serveur.',
      );
      expect(exception.codeStatut, isNull);
    },
  );
}