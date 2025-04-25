import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../personalization/models/address_model.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String docId;
  final String userId;
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
  final double? discount;
  final double? subtotal;
  final double? walletApply;
  final String? userCouponId;

  OrderModel({
    required this.id,
    this.userId = '',
    this.docId = '',
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
    this.discount,
    this.subtotal,
    this.walletApply,
    this.userCouponId,
  });

  String get formattedOrderDate =>
      THelperFunctions.getFormattedDateSpanish(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? THelperFunctions.getFormattedDateSpanish(deliveryDate!)
      : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Entregado'
      : status == OrderStatus.shipped
          ? 'En camino'
          : 'Procesando';

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
      'status': status.toString(), // Enum to string
      'totalAmount': totalAmount,
      'shippingCost': shippingCost,
      'taxCost': taxCost,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'billingAddress': billingAddress?.toJson(), // Convert AddressModel to map
      'shippingAddress':
          shippingAddress?.toJson(), // Convert AddressModel to map
      'deliveryDate': deliveryDate,
      'billingAddressSameAsShipping': billingAddressSameAsShipping,
      'items': items
          .map((item) => item.toJson())
          .toList(), // Convert CartItemModel to map
      'coupon': coupon,
      'discount': discount,
      'subtotal': subtotal,
      'walletApply': walletApply,
      'userCouponId': userCouponId,
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      docId: snapshot.id,
      id: data.containsKey('id') ? data['id'] as String : '',
      userId: data.containsKey('userId') ? data['userId'] as String : '',
      status: data.containsKey('status')
          ? OrderStatus.values.firstWhere((e) => e.toString() == data['status'])
          : OrderStatus.pending,
      // Default status
      totalAmount:
          data.containsKey('totalAmount') ? data['totalAmount'] as double : 0.0,
      shippingCost: data.containsKey('shippingCost')
          ? (data['shippingCost'] as num).toDouble()
          : 0.0,
      taxCost: data.containsKey('taxCost')
          ? (data['taxCost'] as num).toDouble()
          : 0.0,
      orderDate: data.containsKey('orderDate')
          ? (data['orderDate'] as Timestamp).toDate()
          : DateTime.now(),
      // Default to current time
      paymentMethod: data.containsKey('paymentMethod')
          ? data['paymentMethod'] as String
          : '',
      billingAddressSameAsShipping:
          data.containsKey('billingAddressSameAsShipping')
              ? data['billingAddressSameAsShipping'] as bool
              : true,
      billingAddress: data.containsKey('billingAddress')
          ? AddressModel.fromMap(data['billingAddress'] as Map<String, dynamic>)
          : AddressModel.empty(),
      shippingAddress: data.containsKey('shippingAddress')
          ? AddressModel.fromMap(
              data['shippingAddress'] as Map<String, dynamic>)
          : AddressModel.empty(),
      deliveryDate:
          data.containsKey('deliveryDate') && data['deliveryDate'] != null
              ? (data['deliveryDate'] as Timestamp).toDate()
              : null,
      coupon: data['coupon'],
      userCouponId: data['userCouponId'],
      discount: data.containsKey('discount')
          ? (data['discount'] as num).toDouble()
          : 0.0,
      subtotal: data.containsKey('subtotal')
          ? (data['subtotal'] as num).toDouble()
          : 0.0,
      walletApply: data.containsKey('walletApply')
          ? (data['walletApply'] as num).toDouble()
          : 0.0,
      items: data.containsKey('items')
          ? (data['items'] as List<dynamic>)
              .map((itemData) =>
                  CartItemModel.fromJson(itemData as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
