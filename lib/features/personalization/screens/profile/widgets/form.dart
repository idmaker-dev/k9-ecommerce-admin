import 'package:cwt_ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/user_controller.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Column(
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(vertical: TSizes.lg, horizontal: TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detalles del perfil', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: TSizes.spaceBtwSections),

              // First and Last Name
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // First Name
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstNameController,
                            decoration: const InputDecoration(
                              hintText: 'Nombre(s)',
                              label: Text('Nombre8s)'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText('Nombre(s)', value),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),
                        // Last Name
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastNameController,
                            decoration: const InputDecoration(
                              hintText: 'Apellidos',
                              label: Text('Apellidos'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText('Apellidos', value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Email and Phone
                    Row(
                      children: [
                        // First Name
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Correo',
                              label: Text('Correo'),
                              prefixIcon: Icon(Iconsax.forward),
                              enabled: false,
                            ),
                            initialValue: UserController.instance.user.value.email,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        // Last Name
                        Expanded(
                          child: TextFormField(
                            controller: controller.phoneController,
                            decoration: const InputDecoration(
                              hintText: 'Teléfono',
                              label: Text('Teléfono'),
                              prefixIcon: Icon(Iconsax.mobile),
                            ),
                            validator: (value) => TValidator.validateEmptyText('Teléfono', value),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () => controller.loading.value ? () {} : controller.updateUserInformation(),
                    child: controller.loading.value
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : const Text('Actualizar perfil'),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
