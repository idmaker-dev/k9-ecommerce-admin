import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class ProductBottomNavigationButtons extends StatelessWidget {
  const ProductBottomNavigationButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Discard button
          OutlinedButton(
            onPressed: () {
              // Add functionality to discard changes if needed
            },
            child: const Text('Descartar'),
          ),
          const SizedBox(width: TSizes.spaceBtwItems / 2),

          // Save Changes button
          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: () => CreateProductController.instance.createProduct(),
              child: const Text('Guardar cambios'),
            ),
          ),
        ],
      ),
    );
  }
}
