import 'package:cwt_ecommerce_admin_panel/features/personalization/models/coupon_model.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/models/statitics_model.dart';
import 'package:cwt_ecommerce_admin_panel/routes/routes.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class CouponStatsDataSource extends DataTableSource {
  final List<Coupon> couponStats;
  final orderController = OrderController.instance;
  final couponController = CouponController.instance;

  CouponStatsDataSource(this.couponStats);

  @override
  DataRow2? getRow(int index) {
    if (index >= couponStats.length) return null;
    final stat = couponStats[index];
    // couponController.fetchCouponsByUser('');
    return DataRow2(
        onTap: () {
          final order = orderController
              .fetchOrderById(stat.orderId ?? '')
              .then((onValue) {
            Get.toNamed(TRoutes.orderDetails, arguments: onValue);
          });
        },
        cells: [
          DataCell(Text(
            stat.orderId.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text('\$${stat.bonification.toStringAsFixed(2)}')),
          DataCell(Text(
            stat.bonusDelivered == true ? 'Entregado' : 'No entregado',
            style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(
                color: stat.bonusDelivered == true
                    ? TColors.success
                    : TColors.error),
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => couponStats.length;
  @override
  int get selectedRowCount => 0;
}
