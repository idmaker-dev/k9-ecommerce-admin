import 'package:cwt_ecommerce_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/product/product_variations_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/edit_product_controller.dart';
import '../../../../models/product_variation_model.dart';

class ProductVariations extends StatelessWidget {
  const ProductVariations({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final variationController = ProductVariationController.instance;

    return Obx(
      () => EditProductController.instance.productType.value == ProductType.variable
          ? TRoundedContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Variations Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Variaciones del producto', style: Theme.of(context).textTheme.headlineSmall),
                      TextButton(
                        onPressed: () => variationController.removeVariations(context),
                        child: const Text('Quitar variaciones'),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Variations List
                  if (variationController.productVariations.isNotEmpty)
                    ListView.separated(
                      itemCount: variationController.productVariations.length,
                      shrinkWrap: true,
                      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                      itemBuilder: (_, index) {
                        final variation = variationController.productVariations[index];
                        return _buildVariationTile(context, index, variation, variationController);
                      },
                    )
                  else
                    _buildNoVariationsMessage(),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // Helper method to build a variation tile
  Widget _buildVariationTile(
      BuildContext context, int index, ProductVariationModel variation, ProductVariationController variationController) {
    return ExpansionTile(
      backgroundColor: TColors.lightGrey,
      collapsedBackgroundColor: TColors.lightGrey,
      childrenPadding: const EdgeInsets.all(TSizes.md),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
      title: Text(variation.attributeValues.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ')),
      children: [
        // Upload Variation Image
        Obx(
          () => TImageUploader(
            right: 0,
            left: null,
            circular: true,
            imageType: variation.image.value.isNotEmpty ? ImageType.network : ImageType.asset,
            image: variation.image.value.isNotEmpty ? variation.image.value : TImages.defaultImage,
            onIconButtonPressed: () => ProductImagesController.instance.selectVariationImage(variation),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        // Variation Stock, and Pricing
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) => variation.stock = int.parse(value),
                decoration: const InputDecoration(labelText: 'Existencia', hintText: '0'),
                controller: variationController.stockControllersList[index][variation],
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) => variation.price = double.parse(value),
                decoration: const InputDecoration(labelText: 'Precio', hintText: '\$'),
                controller: variationController.priceControllersList[index][variation],
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwInputFields),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) => variation.discountpercentage = double.parse(value),
                controller: variationController.salePriceControllersList[index][variation],
                decoration: const InputDecoration(labelText: 'Precio con descuento', hintText: '\$'),
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        // Variation Description
        TextFormField(
          onChanged: (value) => variation.description = value,
          controller: variationController.descriptionControllersList[index][variation],
          decoration: const InputDecoration(labelText: 'Descripción', hintText: 'Agrega la descripción de esta varición...'),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }

  // Helper method to build message when there are no variations
  Widget _buildNoVariationsMessage() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TRoundedImage(width: 200, height: 200, imageType: ImageType.asset, image: TImages.defaultVariationImageIcon),
          ],
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Text('No hay variaciones agregadas para este producto.'),
      ],
    );
  }
}
