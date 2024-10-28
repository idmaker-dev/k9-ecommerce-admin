import 'package:cwt_ecommerce_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:cwt_ecommerce_admin_panel/common/widgets/loaders/animation_loader.dart';
import 'package:cwt_ecommerce_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/screens/coupon/all_coupons/table/row_coupons.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CouponsStatsTable extends StatelessWidget {

  final BoxConstraints constraints;
  final OrderController orderController;
  const CouponsStatsTable({super.key, required this.constraints, required this.orderController});

  @override
  Widget build(BuildContext context) {
   return Obx(() {
      if (orderController.loading.value) {
        return const Center(child: TLoaderAnimation());
      }

      if (orderController.couponStats.isEmpty) {
        return const TAnimationLoaderWidget(animation: TImages.tableIllustration, text: 'No se encontró nada', height: 200, width: 200);
      }

      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: TPaginatedDataTable(
         
          columns: const [
            DataColumn2(label: Text('Pedido ID')),
            DataColumn2(label: Text('Ganancia')),
            DataColumn2(label: Text('Fecha')),
          ],
          source: CouponStatsDataSource(orderController.couponStats),
       
        ),
      );
    });
  }
}
