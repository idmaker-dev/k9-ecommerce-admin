import 'package:cloud_firestore/cloud_firestore.dart';

class BrandCategoryModel {
  String? id;
  final String brandId;
  final String categoryId;

  BrandCategoryModel({
    this.id,
    required this.brandId,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'brandId': brandId,
      'categoryId': categoryId,
    };
  }

  factory BrandCategoryModel.fromJson(Map<String, dynamic> data, {String? id}) {
    return BrandCategoryModel(
      id: id ?? data['Id'] ?? data['id'],
      brandId: data['brandId'] as String,
      categoryId: data['categoryId'] as String,
    );
  }

  factory BrandCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return BrandCategoryModel.fromJson(snapshot.data() as Map<String, dynamic>? ?? {}, id: snapshot.id);
  }
}
