/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class Requirement {
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

  factory Requirement.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Requirement(
      id: jsonSerialization['id'] as int?,
      sourceDocumentId: jsonSerialization['sourceDocumentId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      deadline: jsonSerialization['deadline'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deadline']),
      isMandatory: jsonSerialization['isMandatory'] as bool,
      status: jsonSerialization['status'] as String,
      proofUrl: jsonSerialization['proofUrl'] as String?,
      dependsOnId: jsonSerialization['dependsOnId'] as int?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

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

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sourceDocumentId': sourceDocumentId,
      'title': title,
      if (description != null) 'description': description,
      if (deadline != null) 'deadline': deadline?.toJson(),
      'isMandatory': isMandatory,
      'status': status,
      if (proofUrl != null) 'proofUrl': proofUrl,
      if (dependsOnId != null) 'dependsOnId': dependsOnId,
      'createdAt': createdAt.toJson(),
    };
  }
}
