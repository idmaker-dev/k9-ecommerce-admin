import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/settings_controller.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    return Column(
      children: [
        // App Settings
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(vertical: TSizes.lg, horizontal: TSizes.md),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Configuración de la aplicación', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: TSizes.spaceBtwSections),

                // App Name
                TextFormField(
                  controller: controller.appNameController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre de la aplicación',
                    label: Text('Nombre de la aplicación'),
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Email and Phone
                Row(
                  children: [
                    // First Name
                    Expanded(
                      child: TextFormField(
                        controller: controller.taxController,
                        decoration: const InputDecoration(
                          hintText: 'Tax %',
                          label: Text('Tax Rate (%)'),
                          prefixIcon: Icon(Iconsax.tag),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    // Last Name
                    Expanded(
                      child: TextFormField(
                        controller: controller.shippingController,
                        decoration: const InputDecoration(
                          hintText: 'Costo de envio',
                          label: Text('Costo de envio (\$)'),
                          prefixIcon: Icon(Iconsax.ship),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    // Last Name
                    Expanded(
                      child: TextFormField(
                        controller: controller.freeShippingThresholdController,
                        decoration: const InputDecoration(
                          hintText: 'Envío gratis después (\$)',
                          label: Text('Envío gratis después (\$)'),
                          prefixIcon: Icon(Iconsax.ship),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields * 2),

                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () => controller.loading.value ? () {} : controller.updateSettingInformation(),
                      child: controller.loading.value
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : const Text('Actualizar configuración'),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
