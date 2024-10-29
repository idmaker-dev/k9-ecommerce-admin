import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/helpers/helper_functions.dart';

class DashboardController extends TBaseController<OrderModel> {
  static DashboardController get instance => Get.find();

  final orderController = Get.put(OrderController());
  final customerController = Get.put(CustomerController());
  final RxList<double> weeklySales = <double>[].obs;
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;

  @override
  Future<List<OrderModel>> fetchItems() async {
    // Fetch Orders if empty
    if (orderController.allItems.isEmpty) {
      await orderController.fetchItems();
    }

    // Fetch Customers if empty
    if (customerController.allItems.isEmpty) {
      await customerController.fetchItems();
    }

    // Reset weeklySales to zeros
    weeklySales.value = List<double>.filled(7, 0.0);

    // Calculate weekly sales
    _calculateWeeklySales();

    // Calculate Order Status counts
    _calculateOrderStatusData();

    return orderController.allItems;
  }

  // Calculate weekly sales
  void _calculateWeeklySales() {
    for (var order in orderController.allItems) {
      final DateTime orderWeekStart = THelperFunctions.getStartOfWeek(order.orderDate);

      // Check if the order is within the current week
      if (orderWeekStart.isBefore(DateTime.now()) && orderWeekStart.add(const Duration(days: 7)).isAfter(DateTime.now())) {
        int index = (order.orderDate.weekday - 1) % 7; // Adjust index based on DateTime weekday representation

        // Ensure the index is non-negative
        index = index < 0 ? index + 7 : index;

        print('OrderDate: ${order.orderDate}, CurrentWeekDay: $orderWeekStart, Index: $index');

        weeklySales[index] += order.totalAmount;
      }
    }
  }

  // Call this function to calculate Order Status counts
  void _calculateOrderStatusData() {
    // Reset status data
    orderStatusData.clear();

    // Map to store total amounts for each status
    totalAmounts.value = {for (var status in OrderStatus.values) status: 0.0};

    for (var order in orderController.allItems) {
      // Update status count
      final OrderStatus status = order.status;
      orderStatusData[status] = (orderStatusData[status] ?? 0) + 1;

      // Calculate total amounts for each status
      totalAmounts[status] = (totalAmounts[status] ?? 0) + order.totalAmount;
    }
  }

  String getDisplayStatusName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.processing:
        return 'En proceso';
      case OrderStatus.shipped:
        return 'Enviado';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.cancelled:
        return 'Cancelado';
      default:
        return 'Desconocido';
    }
  }
 DateTime _getPreviousMonthDate() {
    final int currentMonth = DateTime.now().month;
    final int currentYear = DateTime.now().year;
    return currentMonth == 1 ? DateTime(currentYear - 1, 12) : DateTime(currentYear, currentMonth - 1);
  }

  double _getMonthlyTotal(DateTime date) {
    return orderController.allItems
        .where((x) => x.orderDate.month == date.month && x.orderDate.year == date.year)
        .fold(0.0, (previousValue, element) => previousValue + element.totalAmount);
  }

  int _getMonthlyOrderCount(DateTime date) {
    return orderController.allItems
        .where((x) => x.orderDate.month == date.month && x.orderDate.year == date.year)
        .length;
  }

  int calculateSalesPercentageChange() {
    final DateTime currentDate = DateTime.now();
    final DateTime previousMonthDate = _getPreviousMonthDate();

    final double currentTotal = _getMonthlyTotal(currentDate);
    final double previousTotal = _getMonthlyTotal(previousMonthDate);

    final double percentageChange = previousTotal == 0 
        ? (currentTotal > 0 ? 100.0 : 0.0) 
        : ((currentTotal - previousTotal) / previousTotal) * 100;

    return percentageChange.toInt();
  }

  double calculateAverageOrderValuePercentageChange() {
    final DateTime currentDate = DateTime.now();
    final DateTime previousMonthDate = _getPreviousMonthDate();

    final double currentTotal = _getMonthlyTotal(currentDate);
    final int currentCount = _getMonthlyOrderCount(currentDate);
    final double currentAverage = currentCount > 0 ? currentTotal / currentCount : 0.0;

    final double previousTotal = _getMonthlyTotal(previousMonthDate);
    final int previousCount = _getMonthlyOrderCount(previousMonthDate);
    final double previousAverage = previousCount > 0 ? previousTotal / previousCount : 0.0;

    final double percentageChange = previousAverage == 0 
        ? (currentAverage > 0 ? 100.0 : 0.0)
        : ((currentAverage - previousAverage) / previousAverage) * 100;

    return percentageChange;
  }

  double calculateOrderCountPercentageChange() {
    final DateTime currentDate = DateTime.now();
    final DateTime previousMonthDate = _getPreviousMonthDate();

    final int currentCount = _getMonthlyOrderCount(currentDate);
    final int previousCount = _getMonthlyOrderCount(previousMonthDate);

    final double percentageChange = previousCount == 0 
        ? (currentCount > 0 ? 100.0 : 0.0)  
        : ((currentCount - previousCount) / previousCount) * 100;

    return percentageChange;
  }

  @override
  Future<void> deleteItem(OrderModel item) async {}

  @override
  bool containsSearchQuery(OrderModel item, String query) => false;
}
