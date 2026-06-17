import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../services/supabase/supabase_client.dart';

import '../../../features/shop/models/brand_category_model.dart';
import '../../../features/shop/models/brand_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BrandRepository extends GetxController {
  // Singleton instance of the BrandRepository
  static BrandRepository get instance => Get.find();

  // Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _brandsTable = 'brands';
  static const String _brandCategoryTable = 'brand_categories';

  // Get all brands from the 'Brands' collection
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final rows = await supabase.from(_brandsTable).select();
      final result = (rows as List)
          .map((e) => flattenRow(Map<String, dynamic>.from(e)))
          .map((json) => BrandModel.fromJson(json, id: json['id']?.toString()))
          .toList();
      if (result.isNotEmpty) {
        return result;
      }
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final snapshot = await _db.collection("Brands").get();
      final result = snapshot.docs.map((e) => BrandModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Get all brand categories from the 'BrandCategory' collection
  Future<List<BrandCategoryModel>> getAllBrandCategories() async {
    try {
      final rows = await supabase.from(_brandCategoryTable).select();
      final result = (rows as List)
          .map((e) => flattenRow(Map<String, dynamic>.from(e)))
          .map((json) => BrandCategoryModel.fromJson(json, id: json['id']?.toString()))
          .toList();
      if (result.isNotEmpty) {
        return result;
      }
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final brandCategoryQuery = await _db.collection('BrandCategory').get();
      final brandCategories = brandCategoryQuery.docs.map((doc) => BrandCategoryModel.fromSnapshot(doc)).toList();
      return brandCategories;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Get specific brand categories for a given brand ID
  Future<List<BrandCategoryModel>> getCategoriesOfSpecificBrand(String brandId) async {
    try {
      final rows = await supabase.from(_brandCategoryTable).select().eq('brand_id', brandId);
      final result = (rows as List)
          .map((e) => flattenRow(Map<String, dynamic>.from(e)))
          .map((json) => BrandCategoryModel.fromJson(json, id: json['id']?.toString()))
          .toList();
      if (result.isNotEmpty) {
        return result;
      }
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final brandCategoryQuery = await _db.collection('BrandCategory').where('brandId', isEqualTo: brandId).get();
      final brandCategories = brandCategoryQuery.docs.map((doc) => BrandCategoryModel.fromSnapshot(doc)).toList();
      return brandCategories;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Create a new brand document in the 'Brands' collection
  Future<String> createBrand(BrandModel brand) async {
    try {
      final response = await supabase.from(_brandsTable).insert({'data': brand.toJson()}).select().single();
      return response['id'].toString();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final result = await _db.collection("Brands").add(brand.toJson());
      return result.id;
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

  // Create a new brand category document in the 'BrandCategory' collection
  Future<String> createBrandCategory(BrandCategoryModel brandCategory) async {
    try {
      final response = await supabase.from(_brandCategoryTable).insert({
        'brand_id': brandCategory.brandId,
        'category_id': brandCategory.categoryId,
        'data': brandCategory.toJson(),
      }).select().single();
      return response['id'].toString();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final result = await _db.collection("BrandCategory").add(brandCategory.toJson());
      return result.id;
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

  // Update an existing brand document in the 'Brands' collection
  Future<void> updateBrand(BrandModel brand) async {
    try {
      await supabase.from(_brandsTable).upsert({'id': brand.id, 'data': brand.toJson()});
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Brands").doc(brand.id).update(brand.toJson());
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

  // Delete an existing brand document and its associated brand categories
  Future<void> deleteBrand(BrandModel brand) async {
    try {
      await supabase.from(_brandCategoryTable).delete().eq('brand_id', brand.id);
      await supabase.from(_brandsTable).delete().eq('id', brand.id);
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.runTransaction((transaction) async {
        final brandRef = _db.collection("Brands").doc(brand.id);
        final brandSnap = await transaction.get(brandRef);

        if (!brandSnap.exists) {
          throw Exception("Brand not found");
        }

        final brandCategoriesSnapshot = await _db.collection('BrandCategory').where('brandId', isEqualTo: brand.id).get();
        final brandCategories = brandCategoriesSnapshot.docs.map((e) => BrandCategoryModel.fromSnapshot(e));

        if (brandCategories.isNotEmpty) {
          for (var brandCategory in brandCategories) {
            transaction.delete(_db.collection('BrandCategory').doc(brandCategory.id));
          }
        }

        transaction.delete(brandRef);
      });
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

  // Delete a brand category document in the 'BrandCategory' collection
  Future<void> deleteBrandCategory(String brandCategoryId) async {
    try {
      await supabase.from(_brandCategoryTable).delete().eq('id', brandCategoryId);
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("BrandCategory").doc(brandCategoryId).delete();
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
