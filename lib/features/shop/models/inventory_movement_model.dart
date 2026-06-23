class InventoryMovementModel {
  final String id;
  final String productId;
  final String? companyId;
  final String type;
  final int quantity;
  final int resultingStock;
  final String? reference;
  final DateTime? createdAt;

  const InventoryMovementModel({
    required this.id,
    required this.productId,
    this.companyId,
    required this.type,
    required this.quantity,
    required this.resultingStock,
    this.reference,
    this.createdAt,
  });

  static InventoryMovementModel empty() => const InventoryMovementModel(
        id: '',
        productId: '',
        type: 'entry',
        quantity: 0,
        resultingStock: 0,
      );

  factory InventoryMovementModel.fromJson(Map<String, dynamic> json) {
    return InventoryMovementModel(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      companyId: json['company_id']?.toString(),
      type: json['type']?.toString() ?? 'entry',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      resultingStock: (json['resulting_stock'] as num?)?.toInt() ?? 0,
      reference: json['reference']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
