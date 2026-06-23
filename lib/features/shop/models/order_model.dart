import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../personalization/models/address_model.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String docId;
  final String userId;
  final String? companyId;
  OrderStatus status;
  final double totalAmount;
  final double shippingCost;
  final double taxCost;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? shippingAddress;
  final AddressModel? billingAddress;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;
  final bool billingAddressSameAsShipping;
  final String? coupon;
  final double? subtotal;
  final double? discountAmount;
  final double? rewardAmount;
  final double? total;
  final PaymentStatus paymentStatus;
  FulfillmentStatus fulfillmentStatus;
  final double? commissionRate;
  final double? commissionAmount;
  final double? companyAmount;
  final String? settlementId;
  OrderModel({
    required this.id,
    this.userId = '',
    this.docId = '',
    this.companyId,
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxCost,
    required this.orderDate,
    this.paymentMethod = 'Cash on Delivery',
    this.billingAddress,
    this.shippingAddress,
    this.deliveryDate,
    this.billingAddressSameAsShipping = true,
    this.coupon,
    this.subtotal,
    this.discountAmount,
    this.rewardAmount,
    this.total,
    this.paymentStatus = PaymentStatus.pending,
    this.fulfillmentStatus = FulfillmentStatus.pending,
    this.commissionRate,
    this.commissionAmount,
    this.companyAmount,
    this.settlementId,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null ? THelperFunctions.getFormattedDate(deliveryDate!) : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
          ? 'Shipment on the way'
          : 'Processing';

  /// Static function to create an empty user model.
  static OrderModel empty() => OrderModel(
        id: '',
        items: [],
        orderDate: DateTime.now(),
        status: OrderStatus.pending,
        totalAmount: 0,
        shippingCost: 0,
        taxCost: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'company_id': companyId,
      'status': status.toString(), // Enum to string
      'totalAmount': totalAmount,
      'shippingCost': shippingCost,
      'taxCost': taxCost,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'billingAddress': billingAddress?.toJson(), // Convert AddressModel to map
      'shippingAddress': shippingAddress?.toJson(), // Convert AddressModel to map
      'deliveryDate': deliveryDate,
      'billingAddressSameAsShipping': billingAddressSameAsShipping,
      'items': items.map((item) => item.toJson()).toList(), // Convert CartItemModel to map
      'coupon': coupon,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'reward_amount': rewardAmount,
      'total': total ?? totalAmount,
      'payment_status': paymentStatus.name,
      'fulfillment_status': fulfillmentStatus.name,
      'commission_rate': commissionRate,
      'commission_amount': commissionAmount,
      'company_amount': companyAmount,
      'settlement_id': settlementId,
    };
  }

  static PaymentStatus _paymentStatusFrom(dynamic value) {
    final raw = value?.toString();
    return PaymentStatus.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => PaymentStatus.pending,
    );
  }

  static FulfillmentStatus _fulfillmentStatusFrom(dynamic value) {
    final raw = value?.toString();
    return FulfillmentStatus.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => FulfillmentStatus.pending,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  factory OrderModel.fromJson(Map<String, dynamic> data, {String? docId}) {
    return OrderModel(
      docId: docId ?? data['docId']?.toString() ?? '',
      id: data.containsKey('id') ? data['id'] as String : '',
      userId: data.containsKey('userId') ? data['userId'] as String : '',
        companyId: data['company_id']?.toString() ?? data['CompanyId']?.toString(),
      status: data.containsKey('status')
          ? OrderStatus.values.firstWhere((e) => e.toString() == data['status'], orElse: () => OrderStatus.pending)
          : OrderStatus.pending,
      totalAmount: data.containsKey('totalAmount') ? (data['totalAmount'] as num).toDouble() : 0.0,
      shippingCost: data.containsKey('shippingCost') ? (data['shippingCost'] as num).toDouble() : 0.0,
      taxCost: data.containsKey('taxCost') ? (data['taxCost'] as num).toDouble() : 0.0,
      orderDate: _parseDate(data['orderDate']) ?? DateTime.now(),
      paymentMethod: data.containsKey('paymentMethod') ? data['paymentMethod'] as String : '',
      billingAddressSameAsShipping: data.containsKey('billingAddressSameAsShipping') ? data['billingAddressSameAsShipping'] as bool : true,
      billingAddress:
          data.containsKey('billingAddress') ? AddressModel.fromMap(data['billingAddress'] as Map<String, dynamic>) : AddressModel.empty(),
      shippingAddress: data.containsKey('shippingAddress')
          ? AddressModel.fromMap(data['shippingAddress'] as Map<String, dynamic>)
          : AddressModel.empty(),
      deliveryDate: _parseDate(data['deliveryDate']),
      coupon: data['coupon'],
      items: data.containsKey('items')
          ? (data['items'] as List<dynamic>).map((itemData) => CartItemModel.fromJson(itemData as Map<String, dynamic>)).toList()
          : [],
      subtotal: data['subtotal'] != null ? (data['subtotal'] as num).toDouble() : null,
      discountAmount: data['discount_amount'] != null ? (data['discount_amount'] as num).toDouble() : null,
      rewardAmount: data['reward_amount'] != null ? (data['reward_amount'] as num).toDouble() : null,
      total: data['total'] != null ? (data['total'] as num).toDouble() : null,
      paymentStatus: _paymentStatusFrom(data['payment_status']),
      fulfillmentStatus: _fulfillmentStatusFrom(data['fulfillment_status']),
      commissionRate: data['commission_rate'] != null ? (data['commission_rate'] as num).toDouble() : null,
      commissionAmount: data['commission_amount'] != null ? (data['commission_amount'] as num).toDouble() : null,
      companyAmount: data['company_amount'] != null ? (data['company_amount'] as num).toDouble() : null,
      settlementId: data['settlement_id']?.toString(),
    );
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    return OrderModel.fromJson(snapshot.data() as Map<String, dynamic>? ?? {}, docId: snapshot.id);
  }
}
