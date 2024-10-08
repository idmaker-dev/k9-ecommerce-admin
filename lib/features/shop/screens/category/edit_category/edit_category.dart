import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';
import 'responsive_screens/edit_category_desktop.dart';
import 'responsive_screens/edit_category_mobile.dart';
import 'responsive_screens/edit_category_tablet.dart';

class EditCategoryScreen extends StatelessWidget {
  const EditCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = Get.arguments;
    return category != null
        ? TSiteTemplate(
            desktop: EditCategoryDesktopScreen(category: category),
            tablet: EditCategoryTabletScreen(category: category),
            mobile: EditCategoryMobileScreen(category: category),
          )
        : const TPageNotFound();
  }
}
