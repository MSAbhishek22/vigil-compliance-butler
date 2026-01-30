/* Models for Vigil Server */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/serverpod.dart';

/// SourceDocument model - represents uploaded/parsed compliance documents
class SourceDocument {
  static final db = SourceDocumentRepository._();

  int? id;
  int userId;
  String? url;
  String? filePath;
  String fileType;
  String status;
  String? title;
  String? rawContent;
  DateTime createdAt;
  DateTime updatedAt;

  SourceDocument({
    this.id,
    required this.userId,
    this.url,
    this.filePath,
    required this.fileType,
    required this.status,
    this.title,
    this.rawContent,
    required this.createdAt,
    required this.updatedAt,
  });

  SourceDocument copyWith({
    int? id,
    int? userId,
    String? url,
    String? filePath,
    String? fileType,
    String? status,
    String? title,
    String? rawContent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SourceDocument(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      url: url ?? this.url,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      status: status ?? this.status,
      title: title ?? this.title,
      rawContent: rawContent ?? this.rawContent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (url != null) 'url': url,
      if (filePath != null) 'filePath': filePath,
      'fileType': fileType,
      'status': status,
      if (title != null) 'title': title,
      if (rawContent != null) 'rawContent': rawContent,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SourceDocument.fromJson(Map<String, dynamic> json) {
    return SourceDocument(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      url: json['url'] as String?,
      filePath: json['filePath'] as String?,
      fileType: json['fileType'] as String,
      status: json['status'] as String,
      title: json['title'] as String?,
      rawContent: json['rawContent'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class SourceDocumentRepository {
  SourceDocumentRepository._();

  String _sqlEscape(String? value) {
    if (value == null) return 'NULL';
    return "'${value.replaceAll("'", "''")}'";
  }

  String _sqlDateTime(DateTime? value) {
    if (value == null) return 'NULL';
    return "'${value.toIso8601String()}'";
  }

  Future<SourceDocument> insertRow(Session session, SourceDocument row) async {
    final query = 'INSERT INTO source_documents (user_id, url, file_path, file_type, status, title, raw_content, created_at, updated_at) '
        'VALUES (${row.userId}, ${_sqlEscape(row.url)}, ${_sqlEscape(row.filePath)}, ${_sqlEscape(row.fileType)}, ${_sqlEscape(row.status)}, ${_sqlEscape(row.title)}, ${_sqlEscape(row.rawContent)}, ${_sqlDateTime(row.createdAt)}, ${_sqlDateTime(row.updatedAt)}) '
        'RETURNING id';
    
    final result = await session.db.unsafeQuery(query);
    
    if (result.isNotEmpty) {
      row.id = result.first[0] as int;
    }
    return row;
  }

  Future<SourceDocument?> findById(Session session, int id) async {
    final result = await session.db.unsafeQuery(
      'SELECT * FROM source_documents WHERE id = $id'
    );
    
    if (result.isEmpty) return null;
    return _fromRow(result.first);
  }

  Future<List<SourceDocument>> find(
    Session session, {
    dynamic where,
    dynamic orderBy,
    bool orderDescending = false,
    int? limit,
  }) async {
    var query = 'SELECT * FROM source_documents';
    
    if (orderBy != null) {
      final order = orderDescending ? 'DESC' : 'ASC';
      query = '$query ORDER BY $orderBy $order';
    }
    if (limit != null) {
      query = '$query LIMIT $limit';
    }
    
    final result = await session.db.unsafeQuery(query);
    return result.map(_fromRow).toList();
  }

  Future<void> updateRow(Session session, SourceDocument row) async {
    final query = 'UPDATE source_documents SET '
        'user_id = ${row.userId}, '
        'url = ${_sqlEscape(row.url)}, '
        'file_path = ${_sqlEscape(row.filePath)}, '
        'file_type = ${_sqlEscape(row.fileType)}, '
        'status = ${_sqlEscape(row.status)}, '
        'title = ${_sqlEscape(row.title)}, '
        'raw_content = ${_sqlEscape(row.rawContent)}, '
        'updated_at = ${_sqlDateTime(row.updatedAt)} '
        'WHERE id = ${row.id}';
    
    await session.db.unsafeQuery(query);
  }

  SourceDocument _fromRow(List<dynamic> row) {
    return SourceDocument(
      id: row[0] as int?,
      userId: row[1] as int,
      url: row[2] as String?,
      filePath: row[3] as String?,
      fileType: row[4] as String,
      status: row[5] as String,
      title: row[6] as String?,
      rawContent: row[7] as String?,
      createdAt: row[8] as DateTime,
      updatedAt: row[9] as DateTime,
    );
  }
}
