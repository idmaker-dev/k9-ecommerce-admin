import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Coupon couponModelFromJson(String str) => Coupon.fromJson(json.decode(str));

String couponModelToJson(Coupon data) => json.encode(data.toJson());

class Coupon {
  final String documentId;
  String id;
  final String orderId;
  final double bonification;
  final bool bonusDelivered;
  final int bonusDeliveredType;

  Coupon(
      {required this.documentId,
      required this.id,
      required this.orderId,
      required this.bonification,
      required this.bonusDelivered,
      required this.bonusDeliveredType});

  // empty
  static Coupon empty() => Coupon(
      documentId: '',
      id: '',
      orderId: '',
      bonification: 0.0,
      bonusDelivered: false,
      bonusDeliveredType: 0);

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
      documentId: '',
        id: json["Id"],
        orderId: json["OrderId"],
        bonification: json["Bonification"]?.toDouble(),
        bonusDelivered: json["BonusDelivered"],
        bonusDeliveredType: json["BonusDeliveredType"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "OrderId": orderId,
        "Bonification": bonification,
        "BonusDelivered": bonusDelivered,
        "BonusDeliveredType": bonusDeliveredType,
      };

  factory Coupon.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Coupon(
        documentId: data['DocumentId'],
        id: snapshot.id,
        orderId: data['OrderId'],
        bonification: data['Bonification']?.toDouble(),
        bonusDelivered: data['BonusDelivered'],
        bonusDeliveredType: data['BonusDeliveredType']);
  }

  factory Coupon.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Coupon(
        documentId: document.id,
        id: document.id,
        orderId: data['OrderId'],
        bonification: data['Bonification']?.toDouble(),
        bonusDelivered: data['BonusDelivered'],
        bonusDeliveredType: data['BonusDeliveredType'],
      );
    } else {
      return Coupon.empty();
    }
  }
}
