class AuditLogModel {
  final String id;
  final String? actorId;
  final String? actorRole;
  final String? companyId;
  final String action;
  final String entityType;
  final String? entityId;
  final Map<String, dynamic> detail;
  final DateTime? createdAt;

  const AuditLogModel({
    required this.id,
    this.actorId,
    this.actorRole,
    this.companyId,
    required this.action,
    required this.entityType,
    this.entityId,
    required this.detail,
    this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id']?.toString() ?? '',
      actorId: json['actor_id']?.toString(),
      actorRole: json['actor_role']?.toString(),
      companyId: json['company_id']?.toString(),
      action: json['action']?.toString() ?? '',
      entityType: json['entity_type']?.toString() ?? '',
      entityId: json['entity_id']?.toString(),
      detail: Map<String, dynamic>.from(json['detail'] ?? const {}),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
