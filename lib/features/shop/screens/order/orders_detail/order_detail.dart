import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';
import 'responsive_screens/order_detail_desktop.dart';
import 'responsive_screens/order_detail_mobile.dart';
import 'responsive_screens/order_detail_tablet.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;

    return order != null
        ? TSiteTemplate(
            desktop: OrderDetailDesktopScreen(order: order),
            tablet: OrderDetailTabletScreen(order: order),
            mobile: OrderDetailMobileScreen(order: order),
          )
        : const TPageNotFound();
  }
}
