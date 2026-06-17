import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured = false,
    this.parentId = '',
    this.createdAt,
    this.updatedAt,
  });

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  /// Empty Helper Function
  static CategoryModel empty() => CategoryModel(id: '', image: '', name: '', isFeatured: false);

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  /// Convert model to Json structure so that you can store data in Firebase
  toJson() {
    return {
      'Name': name,
      'Image': image,
      'ParentId': parentId,
      'IsFeatured': isFeatured,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> data, {String? id}) {
    return CategoryModel(
      id: id ?? data['Id'] ?? data['id'] ?? '',
      name: data['Name'] ?? '',
      image: data['Image'] ?? '',
      parentId: data['ParentId'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
      createdAt: _parseDate(data['CreatedAt']),
      updatedAt: _parseDate(data['UpdatedAt']),
    );
  }

  /// Map Json oriented document snapshot from Firebase to UserModel
  factory CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    return CategoryModel.fromJson(document.data() ?? {}, id: document.id);
  }
}
