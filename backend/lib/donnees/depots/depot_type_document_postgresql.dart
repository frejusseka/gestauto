import 'package:postgres/postgres.dart';

import '../../coeur/base_de_donnees/connexion_postgresql.dart';
import '../../domaine/depots/depot_type_document.dart';
import '../../domaine/entites/type_document.dart';

class DepotTypeDocumentPostgresql implements DepotTypeDocument {
  final ConnexionPostgresql _connexionPostgresql;

  DepotTypeDocumentPostgresql({
    required ConnexionPostgresql connexionPostgresql,
  }) : _connexionPostgresql = connexionPostgresql;

  @override
  Future<List<TypeDocument>> obtenirTous({
    required String utilisateurId,
  }) async {
    final resultats = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT id, utilisateur_id, nom
        FROM types_documents
        WHERE utilisateur_id = @utilisateurId
        ORDER BY nom
        ''',
      ),
      parameters: {
        'utilisateurId': utilisateurId,
      },
    );

    return resultats.map((ligne) {
      return _convertirEnTypeDocument(ligne);
    }).toList();
  }

  @override
  Future<TypeDocument?> obtenirParId({
    required String utilisateurId,
    required String typeDocumentId,
  }) async {
    final resultats = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        SELECT id, utilisateur_id, nom
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

    if (resultats.isEmpty) {
      return null;
    }

    return _convertirEnTypeDocument(resultats.first);
  }

  @override
  Future<TypeDocument> creer({
    required String utilisateurId,
    required TypeDocument typeDocument,
  }) async {
    if (typeDocument.utilisateurId != utilisateurId) {
      throw StateError(
        'Le type de document appartient à un autre utilisateur.',
      );
    }

    await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        INSERT INTO types_documents (
          id,
          utilisateur_id,
          nom
        )
        VALUES (
          @id,
          @utilisateurId,
          @nom
        )
        ''',
      ),
      parameters: {
        'id': typeDocument.id,
        'utilisateurId': utilisateurId,
        'nom': typeDocument.nom,
      },
    );

    return typeDocument;
  }

  @override
  Future<TypeDocument> modifier({
    required String utilisateurId,
    required TypeDocument typeDocument,
  }) async {
    if (typeDocument.utilisateurId != utilisateurId) {
      throw StateError(
        'Le type de document appartient à un autre utilisateur.',
      );
    }

    final resultats = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        UPDATE types_documents
        SET nom = @nom
        WHERE id = @id
          AND utilisateur_id = @utilisateurId
        RETURNING id, utilisateur_id, nom
        ''',
      ),
      parameters: {
        'id': typeDocument.id,
        'utilisateurId': utilisateurId,
        'nom': typeDocument.nom,
      },
    );

    if (resultats.isEmpty) {
      throw StateError(
        'Type de document introuvable.',
      );
    }

    return _convertirEnTypeDocument(resultats.first);
  }

  @override
  Future<void> supprimer({
    required String utilisateurId,
    required String typeDocumentId,
  }) async {
    final resultats = await _connexionPostgresql.connexion.execute(
      Sql.named(
        '''
        DELETE FROM types_documents
        WHERE id = @typeDocumentId
          AND utilisateur_id = @utilisateurId
        RETURNING id
        ''',
      ),
      parameters: {
        'typeDocumentId': typeDocumentId,
        'utilisateurId': utilisateurId,
      },
    );

    if (resultats.isEmpty) {
      throw StateError(
        'Type de document introuvable.',
      );
    }
  }

  TypeDocument _convertirEnTypeDocument(ResultRow ligne) {
    return TypeDocument(
      id: ligne[0] as String,
      utilisateurId: ligne[1] as String,
      nom: ligne[2] as String,
    );
  }
}