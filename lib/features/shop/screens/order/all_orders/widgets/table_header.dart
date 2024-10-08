import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/device/device_utility.dart';
import '../../../../controllers/order/order_controller.dart';

class OrderTableHeader extends StatelessWidget {
  const OrderTableHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return Row(
      children: [
        Expanded(flex: !TDeviceUtils.isDesktopScreen(context) ? 0 : 3, child: const SizedBox()),
        Expanded(
          flex: TDeviceUtils.isDesktopScreen(context) ? 2 : 1,
          child: TextFormField(
            controller: controller.searchTextController,
            onChanged: (query) => controller.searchQuery(query),
            decoration: const InputDecoration(hintText: 'Buscar pedido', prefixIcon: Icon(Iconsax.search_normal)),
          ),
        ),
      ],
    );
  }
}