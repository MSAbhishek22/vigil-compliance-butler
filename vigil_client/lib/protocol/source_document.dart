// Client-side SourceDocument model
class SourceDocument {
  final int? id;
  final int userId;
  final String? url;
  final String? filePath;
  final String fileType;
  final String status;
  final String? title;
  final String? rawContent;
  final DateTime createdAt;
  final DateTime updatedAt;

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'url': url,
    'filePath': filePath,
    'fileType': fileType,
    'status': status,
    'title': title,
    'rawContent': rawContent,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
