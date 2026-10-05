import 'package:dart_frog/dart_frog.dart';

import 'package:gestauto_backend/domaine/cas_utilisation/type_document/obtenir_type_document.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/type_document/modifier_type_document.dart';
import 'package:gestauto_backend/domaine/cas_utilisation/type_document/supprimer_type_document.dart';
import 'package:gestauto_backend/domaine/entites/type_document.dart';
import 'package:gestauto_backend/donnees/depots/depot_type_document_postgresql.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  final donneesUtilisateur =
      context.read<Map<String, dynamic>>();

  final utilisateurId =
      donneesUtilisateur['utilisateurId'] as String;

  final depot =
      context.read<DepotTypeDocumentPostgresql>();

  switch (context.request.method) {
    case HttpMethod.get:
      final obtenirTypeDocument = ObtenirTypeDocument(
        depot: depot,
      );

      final typeDocument =
          await obtenirTypeDocument.executer(
        utilisateurId: utilisateurId,
        typeDocumentId: id,
      );

      if (typeDocument == null) {
        return Response.json(
          statusCode: 404,
          body: {
            'message': 'Type de document introuvable.',
          },
        );
      }

      return Response.json(
        body: {
          'id': typeDocument.id,
          'utilisateurId': typeDocument.utilisateurId,
          'nom': typeDocument.nom,
        },
      );

    case HttpMethod.put:
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
        id: id,
        utilisateurId: utilisateurId,
        nom: nom.trim(),
      );

      final modifierTypeDocument = ModifierTypeDocument(
        depot: depot,
      );

      final typeDocumentModifie =
          await modifierTypeDocument.executer(
        utilisateurId: utilisateurId,
        typeDocument: typeDocument,
      );

      return Response.json(
        body: {
          'id': typeDocumentModifie.id,
          'utilisateurId':
              typeDocumentModifie.utilisateurId,
          'nom': typeDocumentModifie.nom,
        },
      );

    case HttpMethod.delete:
      final supprimerTypeDocument =
          SupprimerTypeDocument(
        depot: depot,
      );

      await supprimerTypeDocument.executer(
        utilisateurId: utilisateurId,
        typeDocumentId: id,
      );

      return Response.json(
        body: {
          'message': 'Type de document supprimé.',
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