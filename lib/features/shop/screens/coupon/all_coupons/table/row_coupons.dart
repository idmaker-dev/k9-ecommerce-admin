 import 'package:cwt_ecommerce_admin_panel/features/shop/models/statitics_model.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class CouponStatsDataSource extends DataTableSource {
    final List<StatisticsModel> couponStats;

    CouponStatsDataSource(this.couponStats);

    @override
    DataRow2? getRow(int index) {
      if (index >= couponStats.length) return null;
      final stat = couponStats[index];
      return DataRow2(cells: [
        DataCell(Text(stat.idOrder.toString(), style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: TColors.primary),)),
        DataCell(Text('\$${stat.profit!.toStringAsFixed(2)}')),
        DataCell(Text(DateFormat('dd MMM yyy').format(stat.date))),
      ]);
    }

    @override
    bool get isRowCountApproximate => false;
    @override
    int get rowCount => couponStats.length;
    @override
    int get selectedRowCount => 0;
  }
