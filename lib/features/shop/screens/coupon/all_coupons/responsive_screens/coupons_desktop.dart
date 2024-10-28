import 'package:cwt_ecommerce_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:cwt_ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:cwt_ecommerce_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/models/user_model.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/screens/coupon/all_coupons/table/coupons_stats_table.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/sizes.dart';

class CouponsDesktopScreen extends StatelessWidget {
  const CouponsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerController = Get.put(CustomerController());
    customerController.fetchItemsV2();

    return Scaffold(
      body: Obx(
        () {
          if (customerController.users.isEmpty) {
            return _buildLoadingWidget(); 
          }

         return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 100.0),
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Expanded(
                      child: Column(
                         mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TBreadcrumbsWithHeading(
                            heading: 'Cupones',
                            breadcrumbItems: ['Cupones'],
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          _buildCustomerSection(context, constraints, customerController),
                          const SizedBox(height: TSizes.spaceBtwSections),
                      
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: TLoaderAnimation(),
    );
  }

 Widget _buildCustomerSection(BuildContext context, BoxConstraints constraints, CustomerController controller) {
  return SizedBox(
    width: constraints.maxWidth,
    child: TRoundedContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Cliente',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    SizedBox(
                      width: 200, 
                      child: _buildUserDropdown(controller),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          CouponsStatsTable(constraints: constraints, orderController: Get.find<OrderController>()), 
        ],
      ),
    ),
  );
}

  Widget _buildUserDropdown(CustomerController controller) {
    return DropdownButtonFormField<UserModel>(
        isExpanded: true,
        value: controller.selectedUser.value,
        onChanged: (UserModel? newUser) async {
          if (newUser != null) {
            controller.selectedUser.value = newUser;
            final selectedCoupon = newUser.coupon ?? '';
            await Get.find<OrderController>().fetchOrdersMyCoupon(selectedCoupon);
          }
        },
        items: controller.users.map((user) {
          return DropdownMenuItem<UserModel>(
            value: user,
            child: Text('${user.firstName} ${user.coupon != "" ? user.coupon : 'Sin cupon' }'),
          );
        }).toList(),
      );
  }
}