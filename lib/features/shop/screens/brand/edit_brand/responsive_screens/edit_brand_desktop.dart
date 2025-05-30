import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/brand_model.dart';
import '../widgets/edit_brand_form.dart';

class EditBrandDesktopScreen extends StatelessWidget {
  const EditBrandDesktopScreen({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                  returnToPreviousScreen: true, heading: 'Actualizar marca', breadcrumbItems: [TRoutes.brands, 'Actualizar marca']),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditBrandForm(brand: brand),
            ],
          ),
        ),
      ),
    );
  }
}
