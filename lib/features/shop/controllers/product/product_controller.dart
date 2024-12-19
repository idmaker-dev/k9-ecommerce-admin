import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/product_model.dart';
import '../order/order_controller.dart';

class ProductController extends TBaseController<ProductModel> {
  static ProductController get instance => Get.find();

  final _productRepository = Get.put(ProductRepository());

  @override
  Future<List<ProductModel>> fetchItems() async {
    return await _productRepository.getAllProducts();
  }

  @override
  bool containsSearchQuery(ProductModel item, String query) {
    return item.title.toLowerCase().contains(query.toLowerCase()) ||
        item.brand!.name.toLowerCase().contains(query.toLowerCase()) ||
        item.stock.toString().contains(query) ||
        item.price.toString().contains(query);
  }

  @override
  Future<void> deleteItem(ProductModel item) async {
    // You might want to add a check if any orders of this products exists, delete them first
    final orderController = Get.put(OrderController());

    // If no orders fetched, Fetch them first
    if (orderController.allItems.isEmpty) {
      await orderController.fetchItems();
    }

    // Check if any order exist containing this productId
    final orderExists = orderController.allItems.any((element) => element.items.any((element) => element.productId == item.id));

    if (orderExists) {
      TLoaders.warningSnackBar(title: 'Dependents Exist', message: 'In order to Delete this Product, Delete dependent Orders first.');
      return;
    }
    await _productRepository.deleteProduct(item);
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ProductModel product) => product.title.toLowerCase());
  }

  /// Sorting related code
  void sortByPrice(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ProductModel product) => product.price);
  }

  void sortByDiscount(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ProductModel product) => product.discountpercentage);
  }

  /// Sorting related code
  void sortByStock(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ProductModel product) => product.stock);
  }

  /// Sorting related code
  void sortBySoldItems(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (ProductModel product) => product.soldQuantity);
  }

  /// Get the product price or price range for variations.
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    // If no variations exist, return the simple price or sale price
    if (product.productType == ProductType.single.toString() || product.productVariations!.isEmpty) {
      return (product.price).toString();
    } else {
      // Calculate the smallest and largest prices among variations
      for (var variation in product.productVariations!) {
        // Determine the price to consider (sale price if available, otherwise regular price)
        double priceToConsider = variation.price;

        // Update smallest and largest prices
        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      // If smallest and largest prices are the same, return a single price
      if (smallestPrice.isEqual(largestPrice)) {
        return largestPrice.toString();
      } else {
        // Otherwise, return a price range
        return '$smallestPrice - \$$largestPrice';
      }
    }
  }

  String getProductDiscount(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    // If no variations exist, return the simple price or sale price
    if (product.productType == ProductType.single.toString() || product.productVariations!.isEmpty) {
      return (product.discountpercentage).toString();
    } else {
      // Calculate the smallest and largest prices among variations
      for (var variation in product.productVariations!) {
        // Determine the price to consider (sale price if available, otherwise regular price)
        double discountToConsider = variation.discountpercentage;

        // Update smallest and largest prices
        if (discountToConsider < smallestPrice) {
          smallestPrice = discountToConsider;
        }

        if (discountToConsider > largestPrice) {
          largestPrice = discountToConsider;
        }
      }

      // If smallest and largest prices are the same, return a single price
      if (smallestPrice.isEqual(largestPrice)) {
        return largestPrice.toString();
      } else {
        // Otherwise, return a price range
        return '$smallestPrice - \$$largestPrice';
      }
    }
  }

  /// -- Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? discountpercentage) {
    if (discountpercentage == null || discountpercentage <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - discountpercentage) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// -- Calculate Product Stock
  String getProductStockTotal(ProductModel product) {
    return product.productType == ProductType.single.toString()
        ? product.stock.toString()
        : product.productVariations!.fold<int>(0, (previousValue, element) => previousValue + element.stock).toString();
  }

  /// -- Calculate Product Sold Quantity
  String getProductSoldQuantity(ProductModel product) {
    return product.productType == ProductType.single.toString()
        ? product.soldQuantity.toString()
        : product.productVariations!.fold<int>(0, (previousValue, element) => previousValue + element.soldQuantity).toString();
  }

  /// -- Check Product Stock Status
  String getProductStockStatus(ProductModel product) {
    return product.stock > 0 ? 'En existencia' : 'Sin existencia';
  }
}
