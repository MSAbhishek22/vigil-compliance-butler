/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class VigilJob {
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

  factory VigilJob.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return VigilJob(
      id: jsonSerialization['id'] as int?,
      requirementId: jsonSerialization['requirementId'] as int,
      reminderType: jsonSerialization['reminderType'] as String,
      scheduledAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['scheduledAt']),
      executedAt: jsonSerialization['executedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['executedAt']),
      status: jsonSerialization['status'] as String,
      notificationSent: jsonSerialization['notificationSent'] as bool,
      errorMessage: jsonSerialization['errorMessage'] as String?,
    );
  }

  int? id;

  int requirementId;

  String reminderType;

  DateTime scheduledAt;

  DateTime? executedAt;

  String status;

  bool notificationSent;

  String? errorMessage;

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

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'requirementId': requirementId,
      'reminderType': reminderType,
      'scheduledAt': scheduledAt.toJson(),
      if (executedAt != null) 'executedAt': executedAt?.toJson(),
      'status': status,
      'notificationSent': notificationSent,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }
}
