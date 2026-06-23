class CompanySettlementModel {
  final String id;
  final String companyId;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final double totalAmount;
  final String status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? paidAt;

  const CompanySettlementModel({
    required this.id,
    required this.companyId,
    this.periodStart,
    this.periodEnd,
    required this.totalAmount,
    required this.status,
    this.notes,
    this.createdAt,
    this.paidAt,
  });

  factory CompanySettlementModel.fromJson(Map<String, dynamic> json) {
    return CompanySettlementModel(
      id: json['id']?.toString() ?? '',
      companyId: json['company_id']?.toString() ?? '',
      periodStart: DateTime.tryParse(json['period_start']?.toString() ?? ''),
      periodEnd: DateTime.tryParse(json['period_end']?.toString() ?? ''),
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'draft',
      notes: json['notes']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      paidAt: DateTime.tryParse(json['paid_at']?.toString() ?? ''),
    );
  }
}
