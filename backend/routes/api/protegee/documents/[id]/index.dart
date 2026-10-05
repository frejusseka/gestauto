import 'package:dart_frog/dart_frog.dart';

import 'package:gestauto_backend/domaine/cas_utilisation/document/obtenir_document.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/document/modifier_document.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/document/supprimer_document.dart';
import 'package:gestauto_backend/domaine/entites/document.dart';
import 'package:gestauto_backend/donnees/depots/depot_document_postgresql.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  final donneesUtilisateur =
      context.read<Map<String, dynamic>>();

  final utilisateurId =
      donneesUtilisateur['utilisateurId'] as String;

  final depot =
      context.read<DepotDocumentPostgresql>();

  switch (context.request.method) {
    case HttpMethod.get:
      final obtenirDocument = ObtenirDocument(
        depot: depot,
      );

      final document =
          await obtenirDocument.executer(
        utilisateurId: utilisateurId,
        documentId: id,
      );

      if (document == null) {
        return Response.json(
          statusCode: 404,
          body: {
            'message': 'Document introuvable.',
          },
        );
      }

      return Response.json(
        body: {
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
        },
      );

    case HttpMethod.put:
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
        id: id,
        vehiculeId: vehiculeId.trim(),
        typeDocumentId: typeDocumentId.trim(),
        numero: numero as String?,
        dateEmission: dateEmissionConvertie,
        dateExpiration: dateExpirationConvertie,
        notes: notes as String?,
      );

      final modifierDocument = ModifierDocument(
        depot: depot,
      );

      final documentModifie =
          await modifierDocument.executer(
        utilisateurId: utilisateurId,
        document: document,
      );

      return Response.json(
        body: {
          'id': documentModifie.id,
          'vehiculeId': documentModifie.vehiculeId,
          'typeDocumentId':
              documentModifie.typeDocumentId,
          'numero': documentModifie.numero,
          'dateEmission':
              documentModifie.dateEmission.toIso8601String(),
          'dateExpiration':
              documentModifie.dateExpiration.toIso8601String(),
          'notes': documentModifie.notes,
        },
      );

    case HttpMethod.delete:
      final supprimerDocument = SupprimerDocument(
        depot: depot,
      );

      await supprimerDocument.executer(
        utilisateurId: utilisateurId,
        documentId: id,
      );

      return Response.json(
        body: {
          'message': 'Document supprimé.',
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