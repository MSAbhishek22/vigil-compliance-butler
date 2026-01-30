/* Models for Vigil Server */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/serverpod.dart';

/// Requirement model - represents compliance requirements extracted from documents
class Requirement {
  static final db = RequirementRepository._();

  int? id;
  int sourceDocumentId;
  String title;
  String? description;
  DateTime? deadline;
  bool isMandatory;
  String status;
  String? proofUrl;
  int? dependsOnId;
  DateTime createdAt;

  Requirement({
    this.id,
    required this.sourceDocumentId,
    required this.title,
    this.description,
    this.deadline,
    required this.isMandatory,
    required this.status,
    this.proofUrl,
    this.dependsOnId,
    required this.createdAt,
  });

  Requirement copyWith({
    int? id,
    int? sourceDocumentId,
    String? title,
    String? description,
    DateTime? deadline,
    bool? isMandatory,
    String? status,
    String? proofUrl,
    int? dependsOnId,
    DateTime? createdAt,
  }) {
    return Requirement(
      id: id ?? this.id,
      sourceDocumentId: sourceDocumentId ?? this.sourceDocumentId,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isMandatory: isMandatory ?? this.isMandatory,
      status: status ?? this.status,
      proofUrl: proofUrl ?? this.proofUrl,
      dependsOnId: dependsOnId ?? this.dependsOnId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sourceDocumentId': sourceDocumentId,
      'title': title,
      if (description != null) 'description': description,
      if (deadline != null) 'deadline': deadline!.toIso8601String(),
      'isMandatory': isMandatory,
      'status': status,
      if (proofUrl != null) 'proofUrl': proofUrl,
      if (dependsOnId != null) 'dependsOnId': dependsOnId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      id: json['id'] as int?,
      sourceDocumentId: json['sourceDocumentId'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline'] as String) : null,
      isMandatory: json['isMandatory'] as bool,
      status: json['status'] as String,
      proofUrl: json['proofUrl'] as String?,
      dependsOnId: json['dependsOnId'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class RequirementRepository {
  RequirementRepository._();

  String _sqlEscape(String? value) {
    if (value == null) return 'NULL';
    return "'${value.replaceAll("'", "''")}'";
  }

  String _sqlDateTime(DateTime? value) {
    if (value == null) return 'NULL';
    return "'${value.toIso8601String()}'";
  }

  String _sqlInt(int? value) {
    if (value == null) return 'NULL';
    return value.toString();
  }

  Future<Requirement> insertRow(Session session, Requirement row) async {
    final query = 'INSERT INTO requirements (source_document_id, title, description, deadline, is_mandatory, status, proof_url, depends_on_id, created_at) '
        'VALUES (${row.sourceDocumentId}, ${_sqlEscape(row.title)}, ${_sqlEscape(row.description)}, ${_sqlDateTime(row.deadline)}, ${row.isMandatory}, ${_sqlEscape(row.status)}, ${_sqlEscape(row.proofUrl)}, ${_sqlInt(row.dependsOnId)}, ${_sqlDateTime(row.createdAt)}) '
        'RETURNING id';
    
    final result = await session.db.unsafeQuery(query);
    
    if (result.isNotEmpty) {
      row.id = result.first[0] as int;
    }
    return row;
  }

  Future<Requirement?> findById(Session session, int id) async {
    final result = await session.db.unsafeQuery(
      'SELECT * FROM requirements WHERE id = $id'
    );
    
    if (result.isEmpty) return null;
    return _fromRow(result.first);
  }

  Future<List<Requirement>> find(
    Session session, {
    dynamic where,
    dynamic orderBy,
    bool orderDescending = false,
    int? limit,
  }) async {
    var query = 'SELECT * FROM requirements';
    
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

  Future<void> updateRow(Session session, Requirement row) async {
    final query = 'UPDATE requirements SET '
        'source_document_id = ${row.sourceDocumentId}, '
        'title = ${_sqlEscape(row.title)}, '
        'description = ${_sqlEscape(row.description)}, '
        'deadline = ${_sqlDateTime(row.deadline)}, '
        'is_mandatory = ${row.isMandatory}, '
        'status = ${_sqlEscape(row.status)}, '
        'proof_url = ${_sqlEscape(row.proofUrl)}, '
        'depends_on_id = ${_sqlInt(row.dependsOnId)}, '
        'created_at = ${_sqlDateTime(row.createdAt)} '
        'WHERE id = ${row.id}';
    
    await session.db.unsafeQuery(query);
  }

  Requirement _fromRow(List<dynamic> row) {
    return Requirement(
      id: row[0] as int?,
      sourceDocumentId: row[1] as int,
      title: row[2] as String,
      description: row[3] as String?,
      deadline: row[4] as DateTime?,
      isMandatory: row[5] as bool,
      status: row[6] as String,
      proofUrl: row[7] as String?,
      dependsOnId: row[8] as int?,
      createdAt: row[9] as DateTime,
    );
  }
}
