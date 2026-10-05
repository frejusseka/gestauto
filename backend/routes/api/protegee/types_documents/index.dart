import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

import 'package:gestauto_backend/domaine/cas_utilisation/type_document/creer_type_document.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/type_document/obtenir_types_documents.dart';
import 'package:gestauto_backend/domaine/entites/type_document.dart';
import 'package:gestauto_backend/donnees/depots/depot_type_document_postgresql.dart';

Future<Response> onRequest(RequestContext context) async {
  final donneesUtilisateur =
      context.read<Map<String, dynamic>>();

  final utilisateurId =
      donneesUtilisateur['utilisateurId'] as String;

  final depot =
      context.read<DepotTypeDocumentPostgresql>();

  switch (context.request.method) {
    case HttpMethod.get:
      final obtenirTypesDocuments = ObtenirTypesDocuments(
        depot: depot,
      );

      final typesDocuments =
          await obtenirTypesDocuments.executer(
        utilisateurId: utilisateurId,
      );

      return Response.json(
        body: {
          'typesDocuments': typesDocuments.map((typeDocument) {
            return {
              'id': typeDocument.id,
              'utilisateurId': typeDocument.utilisateurId,
              'nom': typeDocument.nom,
            };
          }).toList(),
        },
      );

    case HttpMethod.post:
      final corps = await context.request.json();

      final nom = corps['nom'];

      if (nom is! String || nom.trim().isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {
            'message':
                'Le nom du type de document est obligatoire.',
          },
        );
      }

      final typeDocument = TypeDocument(
        id: const Uuid().v4(),
        utilisateurId: utilisateurId,
        nom: nom.trim(),
      );

      final creerTypeDocument = CreerTypeDocument(
        depot: depot,
      );

      final typeDocumentCree =
          await creerTypeDocument.executer(
        utilisateurId: utilisateurId,
        typeDocument: typeDocument,
      );

      return Response.json(
        statusCode: 201,
        body: {
          'id': typeDocumentCree.id,
          'utilisateurId':
              typeDocumentCree.utilisateurId,
          'nom': typeDocumentCree.nom,
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