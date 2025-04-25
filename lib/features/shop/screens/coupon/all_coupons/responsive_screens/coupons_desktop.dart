import 'package:clipboard/clipboard.dart';
import 'package:cwt_ecommerce_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:cwt_ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:cwt_ecommerce_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:cwt_ecommerce_admin_panel/features/personalization/models/user_model.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';
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
    final orderController = Get.put(OrderController());
    final couponController = Get.put(CouponController());
    couponController.fetchItemsV2();
    // customerController.fetchItemsV2();

    return Scaffold(
      body: Obx(
        () {
          if (couponController.users.isEmpty) {
            return _buildLoadingWidget();
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 100.0),
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TBreadcrumbsWithHeading(
                          heading: 'Cupones',
                          breadcrumbItems: ['Cupones'],
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        _buildCustomerSection(
                            context, constraints, couponController),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
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

  Widget _buildCustomerSection(BuildContext context, BoxConstraints constraints,
      CouponController controller) {
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
                      const SizedBox(width: 20),
                      //botn de limpiar
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.limpiarUser();
                        },
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            CouponsStatsTable(
              constraints: constraints,
              couponController: controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDropdown(CouponController controller) {
    return DropdownButtonFormField<UserModel>(
      isExpanded: true,
      value: controller.selectedUser.value,
      onChanged: (UserModel? newUser) async {
        if (newUser != null) {
          controller.selectedUser.value = newUser;
          final selectedCoupon = newUser.coupon ?? '';
          await controller.fetchCouponsByUser(newUser.id ?? '');
        }
      },
      items: controller.users.map((user) {
        return DropdownMenuItem<UserModel>(
          value: user,
          child: Text(
              '${user.firstName} ${user.coupon != "" ? user.coupon : 'Sin cupon'}'),
        );
      }).toList(),
    );
  }
}
