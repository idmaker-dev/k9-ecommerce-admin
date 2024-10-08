import 'package:cwt_ecommerce_admin_panel/common/widgets/texts/page_heading.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/dashboard/dashboard_controller.dart';
import '../table/data_table.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/order_status_graph.dart';
import '../widgets/weekly_sales.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TPageHeading(heading: 'Panel'),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Card Stats
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.note,
                        headingIconColor: Colors.blue,
                        headingIconBgColor: Colors.blue.withOpacity(0.1),
                        stats: 25,
                        context: context,
                        title: 'Total de ventas',
                        subTitle:
                            '\$${controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount).toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.external_drive,
                        headingIconColor: Colors.green,
                        headingIconBgColor: Colors.green.withOpacity(0.1),
                        stats: 15,
                        context: context,
                        title: 'Promedio de pedidos',
                        subTitle:
                            '\$${(controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount) / controller.orderController.allItems.length).toStringAsFixed(2)}',
                        icon: Iconsax.arrow_down,
                        color: TColors.error,
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.box,
                        headingIconColor: Colors.deepPurple,
                        headingIconBgColor: Colors.deepPurple.withOpacity(0.1),
                        stats: 44,
                        context: context,
                        title: 'Total de pedidos',
                        subTitle: '\$${controller.orderController.allItems.length}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.user,
                        headingIconColor: Colors.deepOrange,
                        headingIconBgColor: Colors.deepOrange.withOpacity(0.1),
                        context: context,
                        title: 'Visitantes',
                        subTitle: controller.customerController.allItems.length.toString(),
                        stats: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Graphs
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Weekly Sales Graph
                        const TWeeklySalesGraph(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Orders
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TCircularIcon(
                                    icon: Iconsax.box,
                                    backgroundColor: Colors.deepPurple.withOpacity(0.1),
                                    color: Colors.deepPurple,
                                    size: TSizes.md,
                                  ),
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                  Text('Pedidos recientes', style: Theme.of(context).textTheme.headlineSmall),
                                ],
                              ),
                              const SizedBox(height: TSizes.spaceBtwSections),
                              const DashboardOrderTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),
                  Expanded(
                    child: TRoundedContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TCircularIcon(
                                icon: Iconsax.status,
                                backgroundColor: Colors.amber.withOpacity(0.1),
                                color: Colors.amber,
                                size: TSizes.md,
                              ),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              Text('Estatus de pedidos', style: Theme.of(context).textTheme.headlineSmall),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          const OrderStatusPieChart(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
