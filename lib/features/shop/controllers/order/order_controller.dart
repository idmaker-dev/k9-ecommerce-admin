
import 'package:cwt_ecommerce_admin_panel/features/shop/models/cart_item_model.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/models/statitics_model.dart';
import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/order/order_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/order_model.dart';

class OrderController extends TBaseController<OrderModel> {
  static OrderController get instance => Get.find();

  RxBool statusLoader = false.obs;
  var orderStatus = OrderStatus.delivered.obs;
  final _orderRepository = Get.put(OrderRepository());
  RxList<StatisticsModel> couponStats = <StatisticsModel>[].obs;
  final RxBool loading = false.obs;

  @override
  Future<List<OrderModel>> fetchItems() async {
    sortAscending.value = false;
    return await _orderRepository.getAllOrders();
  }


  Future<void> fetchOrdersMyCoupon(String coupon) async {
    couponStats.value = [];

    if (coupon.isEmpty) {
       loading.value = false;
       couponStats.refresh();
      return;
    };

    loading.value = true; 
    try {
        couponStats.value = [];
        final orders = await _orderRepository.getAllOrders();
        final ordersFilter = orders.where((order) => order.coupon == coupon).toList();

        List<StatisticsModel> statisticsList = [];
        for (var item in ordersFilter) {
          final priceDiscount = await _calculateDiscountPrice(item.items);
          statisticsList.add(StatisticsModel(idOrder: item.id, profit: priceDiscount, date: item.orderDate));
        }
        couponStats.assignAll(statisticsList);
    } catch (e) {
        TLoaders.warningSnackBar(title: 'Error', message: 'No se pudieron cargar los datos: $e');
    } finally {
        loading.value = false; 
        couponStats.refresh(); 
    }
  }


  Future<double> _calculateDiscountPrice(List<CartItemModel> list) async {
    final total = list.fold<double>(0.0, (sum, item) => sum + (item.price * item.quantity));
    return total * 0.10; // 10% de descuento
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) => o.totalAmount.toString().toLowerCase());
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) => o.orderDate.toString().toLowerCase());
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) {
    return item.id.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(OrderModel item) async {
    await _orderRepository.deleteOrder(item.docId);
  }

  /// Update Product Status
  Future<void> updateOrderStatus(OrderModel order, OrderStatus newStatus) async {
    try {
      statusLoader.value = true;
      order.status = newStatus;
      await _orderRepository.updateOrderSpecificValue(order.docId, {'status': newStatus.toString()});
      updateItemFromLists(order);
      orderStatus.value = newStatus;
      TLoaders.successSnackBar(title: 'Actualizar', message: 'Estado del pedido actualizado');
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Algo salio mal', message: e.toString());
    } finally {
      statusLoader.value = false;
    }
  }
}
