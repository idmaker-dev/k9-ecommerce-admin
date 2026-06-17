import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';
import 'category_model.dart';

class BrandModel {
  String id;
  String name;
  String image;
  bool isFeatured;
  int? productsCount;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Not mapped
  List<CategoryModel>? brandCategories;

  BrandModel({
    required this.id,
    required this.image,
    required this.name,
    this.isFeatured = false,
    this.productsCount,
    this.createdAt,
    this.updatedAt,
    this.brandCategories,
  });

  /// Empty Helper Function
  static BrandModel empty() => BrandModel(id: '', image: '', name: '');

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  /// Convert model to Json structure so that you can store data in Firebase
  toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'CreatedAt': createdAt,
      'IsFeatured': isFeatured,
      'ProductsCount': productsCount = 0,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory BrandModel.fromJson(Map<String, dynamic> document, {String? id}) {
    final data = document;
    if (data.isEmpty) return BrandModel.empty();
    return BrandModel(
      id: id ?? data['Id'] ?? data['id'] ?? '',
      name: data['Name'] ?? '',
      image: data['Image'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
      productsCount: int.parse((data['ProductsCount'] ?? 0).toString()),
      createdAt: _parseDate(data['CreatedAt']),
      updatedAt: _parseDate(data['UpdatedAt']),
    );
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory BrandModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    return BrandModel.fromJson(document.data() ?? {}, id: document.id);
  }
}
