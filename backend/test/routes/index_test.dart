import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /', () {
    test('répond avec un statut 200 et les informations de GESTAUTO', () {
      final context = _MockRequestContext();

      final response = route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.body(),
        completion(
          equals(
            '{"application":"GESTAUTO","message":"API GESTAUTO opérationnelle"}',
          ),
        ),
      );
    });
  });
}