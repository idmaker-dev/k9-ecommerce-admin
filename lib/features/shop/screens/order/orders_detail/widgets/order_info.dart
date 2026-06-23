import 'package:cwt_ecommerce_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../models/order_model.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    controller.orderStatus.value = order.fulfillmentStatus;
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información del pedido', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fecha'),
                    Text(order.formattedOrderDate, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Articulos'),
                    Text('${order.items.length} Items', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              Expanded(
                flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Estatus'),
                    Obx(
                      () {
                        if (controller.statusLoader.value) return const TShimmerEffect(width: double.infinity, height: 55);
                        return TRoundedContainer(
                          radius: TSizes.cardRadiusSm,
                          padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: 0),
                          backgroundColor: THelperFunctions.getOrderStatusColor(controller.orderStatus.value).withOpacity(0.1),
                          child: DropdownButton<FulfillmentStatus>(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            value: controller.orderStatus.value,
                            onChanged: (FulfillmentStatus? newValue) {
                              if (newValue != null) {
                                controller.updateOrderStatus(order, newValue);
                              }
                            },
                            items: FulfillmentStatus.values.map((FulfillmentStatus status) {
                              return DropdownMenuItem<FulfillmentStatus>(
                                value: status,
                                child: Text(
                                  status.name.capitalize.toString(),
                                  style: TextStyle(color: THelperFunctions.getOrderStatusColor(controller.orderStatus.value)),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    Text(
                      'Pago: ${order.paymentStatus.name.capitalize}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total'),
                    Text('\$${order.totalAmount}', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
