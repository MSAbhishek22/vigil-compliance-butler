// Client-side Requirement model
class Requirement {
  final int? id;
  final int sourceDocumentId;
  final String title;
  final String? description;
  final DateTime? deadline;
  final bool isMandatory;
  final String status;
  final String? proofUrl;
  final int? dependsOnId;
  final DateTime createdAt;

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

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      id: json['id'] as int?,
      sourceDocumentId: json['sourceDocumentId'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      deadline: json['deadline'] != null 
        ? DateTime.parse(json['deadline'] as String) 
        : null,
      isMandatory: json['isMandatory'] as bool,
      status: json['status'] as String,
      proofUrl: json['proofUrl'] as String?,
      dependsOnId: json['dependsOnId'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sourceDocumentId': sourceDocumentId,
    'title': title,
    'description': description,
    'deadline': deadline?.toIso8601String(),
    'isMandatory': isMandatory,
    'status': status,
    'proofUrl': proofUrl,
    'dependsOnId': dependsOnId,
    'createdAt': createdAt.toIso8601String(),
  };
}
