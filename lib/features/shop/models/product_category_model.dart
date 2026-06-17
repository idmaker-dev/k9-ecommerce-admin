import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel {
  final String id;
  final String productId;
  final String categoryId;

  ProductCategoryModel({
    this.id = '',
    required this.productId,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'categoryId': categoryId,
    };
  }

  factory ProductCategoryModel.fromJson(Map<String, dynamic> data, {String? id}) {
    return ProductCategoryModel(
      id: id ?? data['Id'] ?? data['id'] ?? '',
      productId: data['productId'] as String,
      categoryId: data['categoryId'] as String,
    );
  }

  factory ProductCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ProductCategoryModel.fromJson(snapshot.data() as Map<String, dynamic>? ?? {}, id: snapshot.id);
  }
}
