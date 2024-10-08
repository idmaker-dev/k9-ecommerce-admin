import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/shop/models/banner_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BannerRepository extends GetxController {
  // Get instance of BannerRepository using Get.find()
  static BannerRepository get instance => Get.find();

  // Firebase Firestore instance
  final _db = FirebaseFirestore.instance;

  // Get all banners from Firestore
  Future<List<BannerModel>> getAllBanners() async {
    try {
      // Query Firestore collection to get all banners
      final snapshot = await _db.collection("Banners").get();
      // Convert Firestore document snapshots to BannerModel objects
      final result = snapshot.docs.map((e) => BannerModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      throw e.message!;
    } on SocketException catch (e) {
      // Handle Socket exceptions
      throw e.message;
    } on PlatformException catch (e) {
      // Handle Platform exceptions
      throw e.message!;
    } catch (e) {
      // Catch any other exceptions
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Create a new banner in Firestore
  Future<String> createBanner(BannerModel banner) async {
    try {
      // Add the banner to the "Banners" collection in Firestore
      final result = await _db.collection("Banners").add(banner.toJson());
      // Return the ID of the newly created banner
      return result.id;
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      // Handle Format exceptions
      throw const TFormatException();
    } on PlatformException catch (e) {
      // Handle Platform exceptions
      throw TPlatformException(e.code).message;
    } catch (e) {
      // Catch any other exceptions
      throw 'Something went wrong. Please try again';
    }
  }

  // Update an existing banner in Firestore
  Future<void> updateBanner(BannerModel banner) async {
    try {
      // Update the banner with the specified ID in Firestore
      await _db.collection("Banners").doc(banner.id).update(banner.toJson());
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      // Handle Format exceptions
      throw const TFormatException();
    } on PlatformException catch (e) {
      // Handle Platform exceptions
      throw TPlatformException(e.code).message;
    } catch (e) {
      // Catch any other exceptions
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete a banner from Firestore
  Future<void> deleteBanner(String bannerId) async {
    try {
      // Delete the banner with the specified ID from Firestore
      await _db.collection("Banners").doc(bannerId).delete();
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      // Handle Format exceptions
      throw const TFormatException();
    } on PlatformException catch (e) {
      // Handle Platform exceptions
      throw TPlatformException(e.code).message;
    } catch (e) {
      // Catch any other exceptions
      throw 'Something went wrong. Please try again';
    }
  }
}
