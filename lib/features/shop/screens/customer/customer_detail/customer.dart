import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';
import 'responsive_screens/customer_detail_desktop.dart';
import 'responsive_screens/customer_detail_mobile.dart';
import 'responsive_screens/customer_detail_tablet.dart';

class CustomerDetailScreen extends StatelessWidget {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = Get.arguments;

    return customer != null
        ? TSiteTemplate(
            desktop: CustomerDetailDesktopScreen(customer: customer),
            tablet: CustomerDetailTabletScreen(customer: customer),
            mobile: CustomerDetailMobileScreen(customer: customer),
          )
        : const TPageNotFound();
  }
}
