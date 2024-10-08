import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/create_product_controller.dart';

class ProductVisibilityWidget extends StatelessWidget {
  const ProductVisibilityWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateProductController());
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visibility Header
          Text('Visibilidad', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Radio buttons for product visibility
          Obx(
            () => Column(
              children: [
                _buildVisibilityRadioButton(controller, ProductVisibility.published, 'Publicado'),
                _buildVisibilityRadioButton(controller, ProductVisibility.hidden, 'Oculto'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a radio button for product visibility
  Widget _buildVisibilityRadioButton(CreateProductController controller, ProductVisibility value, String label) {
    return RadioMenuButton<ProductVisibility>(
      value: value,
      groupValue: controller.productVisibility.value,
      onChanged: (selection) => controller.productVisibility.value = selection ?? ProductVisibility.hidden,
      child: Text(label),
    );
  }
}