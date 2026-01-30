/* Models for Vigil Server */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/serverpod.dart';

/// VigilJob model - represents scheduled reminder jobs
class VigilJob {
  static final db = VigilJobRepository._();

  int? id;
  int requirementId;
  String reminderType;
  DateTime scheduledAt;
  DateTime? executedAt;
  String status;
  bool notificationSent;
  String? errorMessage;

  VigilJob({
    this.id,
    required this.requirementId,
    required this.reminderType,
    required this.scheduledAt,
    this.executedAt,
    required this.status,
    required this.notificationSent,
    this.errorMessage,
  });

  VigilJob copyWith({
    int? id,
    int? requirementId,
    String? reminderType,
    DateTime? scheduledAt,
    DateTime? executedAt,
    String? status,
    bool? notificationSent,
    String? errorMessage,
  }) {
    return VigilJob(
      id: id ?? this.id,
      requirementId: requirementId ?? this.requirementId,
      reminderType: reminderType ?? this.reminderType,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      executedAt: executedAt ?? this.executedAt,
      status: status ?? this.status,
      notificationSent: notificationSent ?? this.notificationSent,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'requirementId': requirementId,
      'reminderType': reminderType,
      'scheduledAt': scheduledAt.toIso8601String(),
      if (executedAt != null) 'executedAt': executedAt!.toIso8601String(),
      'status': status,
      'notificationSent': notificationSent,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  factory VigilJob.fromJson(Map<String, dynamic> json) {
    return VigilJob(
      id: json['id'] as int?,
      requirementId: json['requirementId'] as int,
      reminderType: json['reminderType'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      executedAt: json['executedAt'] != null ? DateTime.parse(json['executedAt'] as String) : null,
      status: json['status'] as String,
      notificationSent: json['notificationSent'] as bool,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

class VigilJobRepository {
  VigilJobRepository._();

  String _sqlEscape(String? value) {
    if (value == null) return 'NULL';
    return "'${value.replaceAll("'", "''")}'";
  }

  String _sqlDateTime(DateTime? value) {
    if (value == null) return 'NULL';
    return "'${value.toIso8601String()}'";
  }

  Future<VigilJob> insertRow(Session session, VigilJob row) async {
    final query = 'INSERT INTO vigil_jobs (requirement_id, reminder_type, scheduled_at, executed_at, status, notification_sent, error_message) '
        'VALUES (${row.requirementId}, ${_sqlEscape(row.reminderType)}, ${_sqlDateTime(row.scheduledAt)}, ${_sqlDateTime(row.executedAt)}, ${_sqlEscape(row.status)}, ${row.notificationSent}, ${_sqlEscape(row.errorMessage)}) '
        'RETURNING id';
    
    final result = await session.db.unsafeQuery(query);
    
    if (result.isNotEmpty) {
      row.id = result.first[0] as int;
    }
    return row;
  }

  Future<VigilJob?> findById(Session session, int id) async {
    final result = await session.db.unsafeQuery(
      'SELECT * FROM vigil_jobs WHERE id = $id'
    );
    
    if (result.isEmpty) return null;
    return _fromRow(result.first);
  }

  Future<List<VigilJob>> find(
    Session session, {
    dynamic where,
    dynamic orderBy,
    bool orderDescending = false,
    int? limit,
  }) async {
    var query = 'SELECT * FROM vigil_jobs';
    
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

  Future<void> updateRow(Session session, VigilJob row) async {
    final query = 'UPDATE vigil_jobs SET '
        'requirement_id = ${row.requirementId}, '
        'reminder_type = ${_sqlEscape(row.reminderType)}, '
        'scheduled_at = ${_sqlDateTime(row.scheduledAt)}, '
        'executed_at = ${_sqlDateTime(row.executedAt)}, '
        'status = ${_sqlEscape(row.status)}, '
        'notification_sent = ${row.notificationSent}, '
        'error_message = ${_sqlEscape(row.errorMessage)} '
        'WHERE id = ${row.id}';
    
    await session.db.unsafeQuery(query);
  }

  VigilJob _fromRow(List<dynamic> row) {
    return VigilJob(
      id: row[0] as int?,
      requirementId: row[1] as int,
      reminderType: row[2] as String,
      scheduledAt: row[3] as DateTime,
      executedAt: row[4] as DateTime?,
      status: row[5] as String,
      notificationSent: row[6] as bool,
      errorMessage: row[7] as String?,
    );
  }
}
