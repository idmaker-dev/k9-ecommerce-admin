import 'package:cwt_ecommerce_admin_panel/features/shop/models/product_category_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/supabase/supabase_client.dart';
import '../../../features/personalization/controllers/user_controller.dart';
import '../../../utils/constants/enums.dart';

import '../../../features/shop/models/product_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';


/// Repository for managing product-related data and operations.
class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  /// Firestore instance for database interactions.
  final _db = FirebaseFirestore.instance;
  static const String _productsTable = 'products';
  static const String _productCategoryTable = 'product_categories';

  String? get _currentCompanyId {
    return UserController.instance.user.value.companyId;
  }

  bool get _isCompanyAdmin {
    return UserController.instance.user.value.role == AppRole.companyAdmin;
  }

  /* ---------------------------- FUNCTIONS ---------------------------------*/

  /// Create product.
  Future<String> createProduct(ProductModel product) async {
    if (_isCompanyAdmin) {
      return createMyProduct(product);
    }

    try {
      final row = await supabase.from(_productsTable).insert({'data': product.toJson()}).select().single();
      return row['id'].toString();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final result = await _db.collection('Products').add(product.toJson());
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

  /// Create new product category
  Future<String> createProductCategory(ProductCategoryModel productCategory) async {
    try {
      final row = await supabase.from(_productCategoryTable).insert({
        'product_id': productCategory.productId,
        'category_id': productCategory.categoryId,
        'data': productCategory.toJson(),
      }).select().single();
      return row['id'].toString();
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final result = await _db.collection("ProductCategory").add(productCategory.toJson());
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

  /// Update product.
  Future<void> updateProduct(ProductModel product) async {
    if (_isCompanyAdmin) {
      return updateMyProduct(product);
    }

    try {
      await supabase.from(_productsTable).upsert({'id': product.id, 'data': product.toJson()});
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection('Products').doc(product.id).update(product.toJson());
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

  /// Update Product Instance
  Future<void> updateProductSpecificValue(id, Map<String, dynamic> data) async {
    try {
      final row = await supabase.from(_productsTable).select('data').eq('id', id).maybeSingle();
      final current = Map<String, dynamic>.from(row?['data'] ?? {});
      current.addAll(data);
      await supabase.from(_productsTable).upsert({'id': id, 'data': current});
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      await _db.collection('Products').doc(id).update(data);
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

  /// Get limited featured products.
  Future<List<ProductModel>> getAllProducts() async {
    if (_isCompanyAdmin) {
      return getMyProducts();
    }

    try {
      final rows = await supabase.from(_productsTable).select();
      final result = (rows as List)
          .map((e) => flattenRow(Map<String, dynamic>.from(e)))
          .map((json) => ProductModel.fromJson(json, id: json['id']?.toString()))
          .toList();
      if (result.isNotEmpty) {
        return result;
      }
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final snapshot = await _db.collection('Products').get();
      return snapshot.docs.map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get limited featured products.
  Future<List<ProductCategoryModel>> getProductCategories(String productId) async {
    try {
      final rows = await supabase.from(_productCategoryTable).select().eq('product_id', productId);
      final result = (rows as List)
          .map((e) => flattenRow(Map<String, dynamic>.from(e)))
          .map((json) => ProductCategoryModel.fromJson(json, id: json['id']?.toString()))
          .toList();
      if (result.isNotEmpty) {
        return result;
      }
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final snapshot = await _db.collection('ProductCategory').where('productId', isEqualTo: productId).get();
      return snapshot.docs.map((querySnapshot) => ProductCategoryModel.fromSnapshot(querySnapshot)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Remove product category
  Future<void> removeProductCategory(String productId, String categoryId) async {
    try {
      await supabase.from(_productCategoryTable).delete().eq('product_id', productId).eq('category_id', categoryId);
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      final result =
          await _db.collection("ProductCategory").where('productId', isEqualTo: productId).where('categoryId', isEqualTo: categoryId).get();

      for (final doc in result.docs) {
        await doc.reference.delete();
      }
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

  /// Delete product
  Future<void> deleteProduct(ProductModel product) async {
    if (_isCompanyAdmin) {
      return deleteMyProduct(product.id);
    }

    try {
      await supabase.from(_productCategoryTable).delete().eq('product_id', product.id);
      await supabase.from(_productsTable).delete().eq('id', product.id);
      return;
    } catch (_) {
      // Fallback during migration.
    }

    try {
      // Delete all data at once from Firebase Firestore
      await _db.runTransaction((transaction) async {
        final productRef = _db.collection("Products").doc(product.id);
        final productSnap = await transaction.get(productRef);

        if (!productSnap.exists) {
          throw Exception("Product not found");
        }

        // Fetch ProductCategories
        final productCategoriesSnapshot = await _db.collection('ProductCategory').where('productId', isEqualTo: product.id).get();
        final productCategories = productCategoriesSnapshot.docs.map((e) => ProductCategoryModel.fromSnapshot(e));

        if (productCategories.isNotEmpty) {
          for (var productCategory in productCategories) {
            transaction.delete(_db.collection('ProductCategory').doc(productCategory.id));
          }
        }

        transaction.delete(productRef);
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

  Future<String> createMyProduct(ProductModel product) async {
    final companyId = _currentCompanyId;
    if (companyId == null || companyId.isEmpty) {
      throw 'Tu cuenta no tiene una empresa asociada.';
    }

    final json = product.toJson()..['CompanyId'] = companyId;
    final row = await supabase
        .from(_productsTable)
        .insert({'data': json, 'company_id': companyId})
        .select('id')
        .single();

    return row['id'].toString();
  }

  Future<List<ProductModel>> getMyProducts() async {
    final companyId = _currentCompanyId;
    if (companyId == null || companyId.isEmpty) {
      return [];
    }

    final rows = await supabase
        .from(_productsTable)
        .select('id, data, company_id, created_at')
        .eq('company_id', companyId)
        .order('created_at', ascending: false);

    return (rows as List)
        .map((e) => flattenRow(Map<String, dynamic>.from(e)))
        .map((json) => ProductModel.fromJson(json, id: json['id']?.toString()))
        .toList();
  }

  Future<void> updateMyProduct(ProductModel product) async {
    final companyId = _currentCompanyId;
    if (companyId == null || companyId.isEmpty) {
      throw 'Tu cuenta no tiene una empresa asociada.';
    }

    final json = product.toJson()..['CompanyId'] = companyId;
    await supabase
        .from(_productsTable)
        .update({'data': json})
        .eq('id', product.id)
        .eq('company_id', companyId);
  }

  Future<void> deleteMyProduct(String id) async {
    final companyId = _currentCompanyId;
    if (companyId == null || companyId.isEmpty) {
      throw 'Tu cuenta no tiene una empresa asociada.';
    }

    await supabase
        .from(_productCategoryTable)
        .delete()
        .eq('product_id', id);

    await supabase
        .from(_productsTable)
        .delete()
        .eq('id', id)
        .eq('company_id', companyId);
  }
}
