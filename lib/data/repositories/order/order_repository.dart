import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/shop/models/order_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class OrderRepository extends GetxController {
  // Singleton instance of the OrderRepository
  static OrderRepository get instance => Get.find();

  // Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* ---------------------------- FUNCTIONS ---------------------------------*/

  // Get all orders related to the current user
  Future<List<OrderModel>> getAllOrdersWithOutQuery() async {
    try {
      final result = await _db
          .collection('Orders')
          .orderBy('orderDate', descending: true)
          .get();
      return result.docs
          .map((documentSnapshot) => OrderModel.fromSnapshot(documentSnapshot))
          .toList();
    } on FirebaseException catch (e) {
      print('${e}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print('${_}');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('${e}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('${e}');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<OrderModel>> getAllOrders(String coupon) async {
    try {
      final result = await _db
          .collection('Orders')
          .where('coupon', isEqualTo: coupon)
          .orderBy('orderDate', descending: true)
          .get();
      return result.docs
          .map((documentSnapshot) => OrderModel.fromSnapshot(documentSnapshot))
          .toList();
    } on FirebaseException catch (e) {
      print('${e}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print('${_}');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('${e}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('${e}');
      throw 'Something went wrong. Please try again';
    }
  }

  // Store a new user order
  Future<void> addOrder(OrderModel order) async {
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
  Future<void> updateOrderSpecificValue(
      String orderId, Map<String, dynamic> data) async {
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

  // Get a specific order by its ID
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final result =
          await _db.collection('Orders').where('id', isEqualTo: orderId).get();

      if (result.docs.isNotEmpty) {
        return OrderModel.fromSnapshot(result.docs.first);
      } else {
        throw 'Order not found';
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      return OrderModel.empty();
      // throw 'Something went wrong. Please try again';
    }
  }
}
