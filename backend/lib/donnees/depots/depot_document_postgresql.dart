import 'package:postgres/postgres.dart';

import '../../coeur/base_de_donnees/connexion_postgresql.dart';
import '../../domaine/depots/depot_document.dart';
import '../../domaine/entites/document.dart';

class DepotDocumentPostgresql implements DepotDocument {
  final ConnexionPostgresql _connexionPostgresql;

  DepotDocumentPostgresql({
    required ConnexionPostgresql connexionPostgresql,
  }) : _connexionPostgresql = connexionPostgresql;

  @override
  Future<List<Document>> obtenirTous({
    required String utilisateurId,
  }) async {
    final resultats = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          d.id,
          d.vehicule_id,
          d.type_document_id,
          d.numero,
          d.date_emission,
          d.date_expiration,
          d.notes
        FROM documents d
        INNER JOIN vehicules v
          ON v.id = d.vehicule_id
        INNER JOIN types_documents td
          ON td.id = d.type_document_id
        WHERE v.utilisateur_id = @utilisateurId
          AND td.utilisateur_id = @utilisateurId
        ORDER BY d.date_expiration
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
      },
    );

    return resultats.map((ligne) {
      return _convertirEnDocument(ligne);
    }).toList();
  }

  @override
  Future<List<Document>> obtenirParVehicule({
    required String utilisateurId,
    required String vehiculeId,
  }) async {
    final resultats = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          d.id,
          d.vehicule_id,
          d.type_document_id,
          d.numero,
          d.date_emission,
          d.date_expiration,
          d.notes
        FROM documents d
        INNER JOIN vehicules v
          ON v.id = d.vehicule_id
        INNER JOIN types_documents td
          ON td.id = d.type_document_id
        WHERE d.vehicule_id = @vehiculeId
          AND v.utilisateur_id = @utilisateurId
          AND td.utilisateur_id = @utilisateurId
        ORDER BY d.date_expiration
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
        'utilisateurId': utilisateurId,
      },
    );

    return resultats.map((ligne) {
      return _convertirEnDocument(ligne);
    }).toList();
  }

  @override
  Future<Document?> obtenirParId({
    required String utilisateurId,
    required String documentId,
  }) async {
    final resultats = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT
          d.id,
          d.vehicule_id,
          d.type_document_id,
          d.numero,
          d.date_emission,
          d.date_expiration,
          d.notes
        FROM documents d
        INNER JOIN vehicules v
          ON v.id = d.vehicule_id
        INNER JOIN types_documents td
          ON td.id = d.type_document_id
        WHERE d.id = @documentId
          AND v.utilisateur_id = @utilisateurId
          AND td.utilisateur_id = @utilisateurId
        LIMIT 1
        ''',
      ),
      parameters: {
        'documentId': documentId,
        'utilisateurId': utilisateurId,
      },
    );

    if (resultats.isEmpty) {
      return null;
    }

    return _convertirEnDocument(resultats.first);
  }

  @override
  Future<Document> creer({
    required String utilisateurId,
    required Document document,
  }) async {
    await _verifierProprietes(
      utilisateurId: utilisateurId,
      vehiculeId: document.vehiculeId,
      typeDocumentId: document.typeDocumentId,
    );

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        INSERT INTO documents (
          id,
          vehicule_id,
          type_document_id,
          numero,
          date_emission,
          date_expiration,
          notes
        )
        VALUES (
          @id,
          @vehiculeId,
          @typeDocumentId,
          @numero,
          @dateEmission,
          @dateExpiration,
          @notes
        )
        ''',
      ),
      parameters: {
        'id': document.id,
        'vehiculeId': document.vehiculeId,
        'typeDocumentId': document.typeDocumentId,
        'numero': document.numero,
        'dateEmission': document.dateEmission,
        'dateExpiration': document.dateExpiration,
        'notes': document.notes,
      },
    );

    return document;
  }

  @override
  Future<Document> modifier({
    required String utilisateurId,
    required Document document,
  }) async {
    await _verifierProprietes(
      utilisateurId: utilisateurId,
      vehiculeId: document.vehiculeId,
      typeDocumentId: document.typeDocumentId,
    );

    final resultats = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        UPDATE documents
        SET
          vehicule_id = @vehiculeId,
          type_document_id = @typeDocumentId,
          numero = @numero,
          date_emission = @dateEmission,
          date_expiration = @dateExpiration,
          notes = @notes
        WHERE id = @id
          AND EXISTS (
            SELECT 1
            FROM vehicules v
            WHERE v.id = @vehiculeId
              AND v.utilisateur_id = @utilisateurId
          )
          AND EXISTS (
            SELECT 1
            FROM types_documents td
            WHERE td.id = @typeDocumentId
              AND td.utilisateur_id = @utilisateurId
          )
        RETURNING
          id,
          vehicule_id,
          type_document_id,
          numero,
          date_emission,
          date_expiration,
          notes
        ''',
      ),
      parameters: {
        'id': document.id,
        'vehiculeId': document.vehiculeId,
        'typeDocumentId': document.typeDocumentId,
        'numero': document.numero,
        'dateEmission': document.dateEmission,
        'dateExpiration': document.dateExpiration,
        'notes': document.notes,
        'utilisateurId': utilisateurId,
      },
    );

    if (resultats.isEmpty) {
      throw StateError(
        'Document introuvable.',
      );
    }

    return _convertirEnDocument(resultats.first);
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String documentId,
  }) async {
    final resultats = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM documents
        WHERE id = @documentId
          AND EXISTS (
            SELECT 1
            FROM vehicules v
            WHERE v.id = documents.vehicule_id
              AND v.utilisateur_id = @utilisateurId
          )
          AND EXISTS (
            SELECT 1
            FROM types_documents td
            WHERE td.id = documents.type_document_id
              AND td.utilisateur_id = @utilisateurId
          )
        RETURNING id
        ''',
      ),
      parameters: {
        'documentId': documentId,
        'utilisateurId': utilisateurId,
      },
    );

    if (resultats.isEmpty) {
      throw StateError(
        'Document introuvable.',
      );
    }
  }

  Future<void> _verifierProprietes({
    required String utilisateurId,
    required String vehiculeId,
    required String typeDocumentId,
  }) async {
    final vehicule = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT id
        FROM vehicules
        WHERE id = @vehiculeId
          AND utilisateur_id = @utilisateurId
        LIMIT 1
        ''',
      ),
      parameters: {
        'vehiculeId': vehiculeId,
        'utilisateurId': utilisateurId,
      },
    );

    if (vehicule.isEmpty) {
      throw StateError(
        'Véhicule introuvable ou non autorisé.',
      );
    }

    final typeDocument = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT id
        FROM types_documents
        WHERE id = @typeDocumentId
          AND utilisateur_id = @utilisateurId
        LIMIT 1
        ''',
      ),
      parameters: {
        'typeDocumentId': typeDocumentId,
        'utilisateurId': utilisateurId,
      },
    );

    if (typeDocument.isEmpty) {
      throw StateError(
        'Type de document introuvable ou non autorisé.',
      );
    }
  }

  Document _convertirEnDocument(ResultRow ligne) {
    return Document(
      id: ligne[0] as String,
      vehiculeId: ligne[1] as String,
      typeDocumentId: ligne[2] as String,
      numero: ligne[3] as String?,
      dateEmission: ligne[4] as DateTime,
      dateExpiration: ligne[5] as DateTime,
      notes: ligne[6] as String?,
    );
  }
}