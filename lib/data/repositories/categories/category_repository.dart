import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/supabase/supabase_client.dart';

import '../../../features/shop/models/category_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class CategoryRepository extends GetxController {
  // Singleton instance of the CategoryRepository
  static CategoryRepository get instance => Get.find();

  // Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _categoriesTable = 'categories';

  // Get all categories from the 'Categories' collection
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final rows = await supabase.from(_categoriesTable).select();
      final result = (rows as List)
          .map((e) => flattenRow(Map<String, dynamic>.from(e)))
          .map((json) => CategoryModel.fromJson(json, id: json['id']?.toString()))
          .toList();
      if (result.isNotEmpty) {
        return result;
      }
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final snapshot = await _db.collection("Categories").get();
      final result = snapshot.docs.map((e) => CategoryModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Create a new category document in the 'Categories' collection
  Future<String> createCategory(CategoryModel category) async {
    try {
      final response = await supabase.from(_categoriesTable).insert({'data': category.toJson()}).select().single();
      return response['id'].toString();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final data = await _db.collection("Categories").add(category.toJson());
      return data.id;
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

  // Update an existing category document in the 'Categories' collection
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await supabase.from(_categoriesTable).upsert({'id': category.id, 'data': category.toJson()});
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Categories").doc(category.id).update(category.toJson());
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

  // Delete an existing category document from the 'Categories' collection
  Future<void> deleteCategory(String categoryId) async {
    try {
      await supabase.from(_categoriesTable).delete().eq('id', categoryId);
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection("Categories").doc(categoryId).delete();
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
