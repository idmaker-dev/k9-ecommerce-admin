import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/supabase/supabase_client.dart';

import '../../../features/shop/models/order_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class OrderRepository extends GetxController {
  // Singleton instance of the OrderRepository
  static OrderRepository get instance => Get.find();

  // Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _ordersTable = 'orders';

  /* ---------------------------- FUNCTIONS ---------------------------------*/

  // Get all orders related to the current user
  Future<List<OrderModel>> getAllOrders(String coupon) async {
    try {
      final rows = await supabase.from(_ordersTable).select().eq('coupon', coupon).order('order_date', ascending: false);
      return (rows as List)
          .map((e) => flattenRow(Map<String, dynamic>.from(e)))
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final result = await _db.collection('Orders')
          .where('coupon', isEqualTo: coupon)
          .orderBy('orderDate', descending: true).get();
      return result.docs.map((documentSnapshot) => OrderModel.fromSnapshot(documentSnapshot)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Store a new user order
  Future<void> addOrder(OrderModel order) async {
    try {
      await supabase.from(_ordersTable).insert({'data': order.toJson()});
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection('Orders').add(order.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update a specific value of an order instance
  Future<void> updateOrderSpecificValue(String orderId, Map<String, dynamic> data) async {
    try {
      final row = await supabase.from(_ordersTable).select('data').eq('id', orderId).maybeSingle();
      final current = Map<String, dynamic>.from(row?['data'] ?? {});
      current.addAll(data);
      await supabase.from(_ordersTable).upsert({'id': orderId, 'data': current});
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection('Orders').doc(orderId).update(data);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete an order
  Future<void> deleteOrder(String orderId) async {
    try {
      await supabase.from(_ordersTable).delete().eq('id', orderId);
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Orders").doc(orderId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
