import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ProductVariationModel {
  final String id;
  String sku;
  Rx<String> image;
  String? description;
  double price;
  double discountpercentage;
  int stock;
  int soldQuantity;
  Map<String, String> attributeValues;

  ProductVariationModel({
    required this.id,
    this.sku = '',
    String image = '',
    this.description = '',
    this.price = 0.0,
    this.discountpercentage = 0.0,
    this.stock = 0,
    this.soldQuantity = 0,
    required this.attributeValues,
  }) : image = image.obs;

  /// Create Empty func for clean code
  static ProductVariationModel empty() => ProductVariationModel(id: '', attributeValues: {});

  /// Json Format
  toJson() {
    return {
      'Id': id,
      'Image': image.value,
      'Description': description,
      'Price': price,
      'DiscountPercentage': discountpercentage,
      'SKU': sku,
      'Stock': stock,
      'SoldQuantity': soldQuantity,
      'AttributeValues': attributeValues,
    };
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory ProductVariationModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductVariationModel.empty();
    return ProductVariationModel(
      id: data['Id'] ?? '',
      price: double.parse((data['Price'] ?? 0.0).toString()),
      sku: data['SKU'] ?? '',
      description: data['Description'] ?? '',
      stock: data['Stock'] ?? 0,
      soldQuantity: data['SoldQuantity'] ?? 0,
      discountpercentage: double.parse((data['DiscountPercentage'] ?? 0.0).toString()),
      image: data['Image'] ?? '',
      attributeValues: Map<String, String>.from(data['AttributeValues']),
    );
  }
}
