/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class SourceDocument {
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

  factory SourceDocument.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SourceDocument(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      url: jsonSerialization['url'] as String?,
      filePath: jsonSerialization['filePath'] as String?,
      fileType: jsonSerialization['fileType'] as String,
      status: jsonSerialization['status'] as String,
      title: jsonSerialization['title'] as String?,
      rawContent: jsonSerialization['rawContent'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

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

  @override
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
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }
}
