import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:gestauto_backend/domaine/cas_utilisation/document/creer_document.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/document/obtenir_documents.dart';
import 'package:gestauto_backend/domaine/entites/document.dart';
import 'package:gestauto_backend/donnees/depots/depot_document_postgresql.dart';

Future<Response> onRequest(RequestContext context) async {
  final donneesUtilisateur =
      context.read<Map<String, dynamic>>();

  final utilisateurId =
      donneesUtilisateur['utilisateurId'] as String;

  final depot =
      context.read<DepotDocumentPostgresql>();

  switch (context.request.method) {
    case HttpMethod.get:
      final vehiculeId =
          context.request.uri.queryParameters['vehiculeId'];

      if (vehiculeId != null && vehiculeId.isNotEmpty) {
        final documents =
            await depot.obtenirParVehicule(
          utilisateurId: utilisateurId,
          vehiculeId: vehiculeId,
        );

        return Response.json(
          body: {
            'documents': documents.map((document) {
              return {
                'id': document.id,
                'vehiculeId': document.vehiculeId,
                'typeDocumentId':
                    document.typeDocumentId,
                'numero': document.numero,
                'dateEmission':
                    document.dateEmission.toIso8601String(),
                'dateExpiration':
                    document.dateExpiration.toIso8601String(),
                'notes': document.notes,
              };
            }).toList(),
          },
        );
      }

      final obtenirDocuments = ObtenirDocuments(
        depot: depot,
      );

      final documents =
          await obtenirDocuments.executer(
        utilisateurId: utilisateurId,
      );

      return Response.json(
        body: {
          'documents': documents.map((document) {
            return {
              'id': document.id,
              'vehiculeId': document.vehiculeId,
              'typeDocumentId':
                  document.typeDocumentId,
              'numero': document.numero,
              'dateEmission':
                  document.dateEmission.toIso8601String(),
              'dateExpiration':
                  document.dateExpiration.toIso8601String(),
              'notes': document.notes,
            };
          }).toList(),
        },
      );

    case HttpMethod.post:
      final corps = await context.request.json();

      final vehiculeId = corps['vehiculeId'];
      final typeDocumentId = corps['typeDocumentId'];
      final numero = corps['numero'];
      final dateEmission = corps['dateEmission'];
      final dateExpiration = corps['dateExpiration'];
      final notes = corps['notes'];

      if (vehiculeId is! String ||
          vehiculeId.trim().isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {
            'message': 'Le véhicule est obligatoire.',
          },
        );
      }

      if (typeDocumentId is! String ||
          typeDocumentId.trim().isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {
            'message':
                'Le type de document est obligatoire.',
          },
        );
      }

      if (dateEmission is! String ||
          dateEmission.trim().isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {
            'message':
                'La date d émission est obligatoire.',
          },
        );
      }

      if (dateExpiration is! String ||
          dateExpiration.trim().isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {
            'message':
                'La date d expiration est obligatoire.',
          },
        );
      }

      DateTime dateEmissionConvertie;
      DateTime dateExpirationConvertie;

      try {
        dateEmissionConvertie =
            DateTime.parse(dateEmission);
        dateExpirationConvertie =
            DateTime.parse(dateExpiration);
      } catch (_) {
        return Response.json(
          statusCode: 400,
          body: {
            'message': 'Format de date invalide.',
          },
        );
      }

      if (numero != null && numero is! String) {
        return Response.json(
          statusCode: 400,
          body: {
            'message':
                'Le numéro doit être une chaîne de caractères.',
          },
        );
      }

      if (notes != null && notes is! String) {
        return Response.json(
          statusCode: 400,
          body: {
            'message':
                'Les notes doivent être une chaîne de caractères.',
          },
        );
      }

      final document = Document(
        id: const Uuid().v4(),
        vehiculeId: vehiculeId.trim(),
        typeDocumentId: typeDocumentId.trim(),
        numero: numero as String?,
        dateEmission: dateEmissionConvertie,
        dateExpiration: dateExpirationConvertie,
        notes: notes as String?,
      );

      final creerDocument = CreerDocument(
        depot: depot,
      );

      final documentCree =
          await creerDocument.executer(
        utilisateurId: utilisateurId,
        document: document,
      );

      return Response.json(
        statusCode: 201,
        body: {
          'id': documentCree.id,
          'vehiculeId': documentCree.vehiculeId,
          'typeDocumentId':
              documentCree.typeDocumentId,
          'numero': documentCree.numero,
          'dateEmission':
              documentCree.dateEmission.toIso8601String(),
          'dateExpiration':
              documentCree.dateExpiration.toIso8601String(),
          'notes': documentCree.notes,
        },
      );

    default:
      return Response.json(
        statusCode: 405,
        body: {
          'message': 'Méthode HTTP non autorisée.',
        },
      );
  }
}