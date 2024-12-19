import 'package:cwt_ecommerce_admin_panel/common/widgets/chips/rounded_choice_chips.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:cwt_ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../controllers/brand/create_brand_controller.dart';
import '../../../../controllers/category/category_controller.dart';

class CreateBrandForm extends StatelessWidget {
  const CreateBrandForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateBrandController());
    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: TSizes.sm),
            Text('Crear nueva marca', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: controller.name,
              validator: (value) => TValidator.validateEmptyText('Nombre', value),
              decoration: const InputDecoration(labelText: 'Nombre de la marca', prefixIcon: Icon(Iconsax.box)),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),
            Text('Seleccionar Categorías', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Obx(() => Wrap(
                  spacing: TSizes.sm,
                  children: CategoryController.instance.allItems
                      .map((element) => Padding(
                            padding: const EdgeInsets.only(bottom: TSizes.sm),
                            child: TChoiceChip(
                                text: element.name,
                                selected: controller.selectedCategories.contains(element),
                                onSelected: (value) => controller.toggleSelection(element)),
                          ))
                      .toList(),
                )),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Image Uploader & Featured Checkbox
            Obx(
              () => TImageUploader(
                width: 80,
                height: 80,
                image: controller.imageURL.value.isNotEmpty ? controller.imageURL.value : TImages.defaultImage,
                imageType: controller.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                onIconButtonPressed: () => controller.pickImage(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Obx(
              () => CheckboxMenuButton(
                value: controller.isFeatured.value,
                onChanged: (value) => controller.isFeatured.value = value ?? false,
                child: const Text('Mostrar'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => controller.createBrand(), child: const Text('Crear')),
                      ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
