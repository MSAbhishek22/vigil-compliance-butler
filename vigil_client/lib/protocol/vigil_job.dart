// Client-side VigilJob model
class VigilJob {
  final int? id;
  final int requirementId;
  final String reminderType;
  final DateTime scheduledAt;
  final DateTime? executedAt;
  final String status;
  final bool notificationSent;
  final String? errorMessage;

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

  factory VigilJob.fromJson(Map<String, dynamic> json) {
    return VigilJob(
      id: json['id'] as int?,
      requirementId: json['requirementId'] as int,
      reminderType: json['reminderType'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      executedAt: json['executedAt'] != null 
        ? DateTime.parse(json['executedAt'] as String) 
        : null,
      status: json['status'] as String,
      notificationSent: json['notificationSent'] as bool,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'requirementId': requirementId,
    'reminderType': reminderType,
    'scheduledAt': scheduledAt.toIso8601String(),
    'executedAt': executedAt?.toIso8601String(),
    'status': status,
    'notificationSent': notificationSent,
    'errorMessage': errorMessage,
  };
}
