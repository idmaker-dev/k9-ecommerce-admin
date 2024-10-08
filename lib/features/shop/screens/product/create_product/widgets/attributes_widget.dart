import 'package:cwt_ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/shop/controllers/product/product_variations_controller.dart';
import 'package:cwt_ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:cwt_ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class ProductAttributes extends StatelessWidget {
  ProductAttributes({
    super.key,
  });

  // Controllers
  final attributeController = Get.put(ProductAttributesController());
  final variationController = Get.put(ProductVariationController());

  @override
  Widget build(BuildContext context) {
    final productController = CreateProductController.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider based on product type
        Obx(() => productController.productType.value == ProductType.single
            ? const Divider(color: TColors.primaryBackground)
            : const SizedBox.shrink()),
        Obx(() => productController.productType.value == ProductType.single
            ? const SizedBox(height: TSizes.spaceBtwSections)
            : const SizedBox.shrink()),

        Text('Agregar atributos de producto', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: TSizes.spaceBtwItems),

        // Form to add new attribute
        Form(
          key: attributeController.attributesFormKey,
          child: TDeviceUtils.isDesktopScreen(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildAttributeName(attributeController),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      flex: 2,
                      child: _buildAttributes(attributeController),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    _buildAddAttributeButton(attributeController),
                  ],
                )
              : Column(
                  children: [
                    _buildAttributeName(attributeController),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    _buildAttributes(attributeController),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    _buildAddAttributeButton(attributeController),
                  ],
                ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        // List of added attributes
        Text('Todos los atributos', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: TSizes.spaceBtwItems),

        // Display added attributes in a rounded container
        TRoundedContainer(
          backgroundColor: TColors.primaryBackground,
          child: Obx(
            () => attributeController.productAttributes.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    itemCount: attributeController.productAttributes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                    itemBuilder: (_, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: TColors.white,
                          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                        ),
                        child: ListTile(
                          title: Text(attributeController.productAttributes[index].name ?? ''),
                          subtitle: Text(attributeController.productAttributes[index].values!.map((e) => e.trim()).toString()),
                          trailing: IconButton(
                            onPressed: () => attributeController.removeAttribute(index, context),
                            icon: const Icon(Iconsax.trash, color: TColors.error),
                          ),
                        ),
                      );
                    },
                  )
                : const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TRoundedImage(width: 150, height: 80, imageType: ImageType.asset, image: TImages.defaultAttributeColorsImageIcon),
                        ],
                      ),
                      SizedBox(height: TSizes.spaceBtwItems),
                      Text('No hay atributos agregados para este producto.'),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwSections),

        // Generate Variations Button
        Obx(
          () => productController.productType.value == ProductType.variable && variationController.productVariations.isEmpty
              ? Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      icon: const Icon(Iconsax.activity),
                      label: const Text('Generar variaciones'),
                      onPressed: () => variationController.generateVariationsConfirmation(context),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // Build button to add a new attribute
  SizedBox _buildAddAttributeButton(ProductAttributesController controller) {
    return SizedBox(
      width: 100,
      child: ElevatedButton.icon(
        onPressed: () => controller.addNewAttribute(),
        icon: const Icon(Iconsax.add),
        style: ElevatedButton.styleFrom(
          foregroundColor: TColors.black,
          backgroundColor: TColors.secondary,
          side: const BorderSide(color: TColors.secondary),
        ),
        label: const Text('Agregar'),
      ),
    );
  }

  // Build text form field for attribute name
  TextFormField _buildAttributeName(ProductAttributesController controller) {
    return TextFormField(
      controller: controller.attributeName,
      validator: (value) => TValidator.validateEmptyText('Nombre del atributo', value),
      decoration: const InputDecoration(labelText: 'Nombre del atributo', hintText: 'Colores, Tamaños, Materiales'),
    );
  }

  // Build text form field for attribute values
  SizedBox _buildAttributes(ProductAttributesController controller) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        expands: true,
        maxLines: null,
        textAlign: TextAlign.start,
        controller: controller.attributes,
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
        validator: (value) => TValidator.validateEmptyText('Campos de artibutos', value),
        decoration: const InputDecoration(
          labelText: 'Atributos',
          hintText: 'Agregar atributos separados por |  Ejemplo: Verde | Azul | Amarillo',
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
