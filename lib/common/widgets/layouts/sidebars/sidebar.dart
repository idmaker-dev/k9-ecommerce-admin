import 'package:cwt_ecommerce_admin_panel/features/personalization/controllers/settings_controller.dart';
import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../images/t_circular_image.dart';
import 'menu/menu_item.dart';

/// Sidebar widget for navigation menu
class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(width: 1, color: TColors.grey)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Obx(
                    () => TCircularImage(
                      width: 60,
                      height: 60,
                      padding: 0,
                      margin: TSizes.sm,
                      backgroundColor: Colors.transparent,
                      imageType: SettingsController.instance.settings.value.appLogo.isNotEmpty ? ImageType.network : ImageType.asset,
                      image: SettingsController.instance.settings.value.appLogo.isNotEmpty
                          ? SettingsController.instance.settings.value.appLogo
                          : TImages.k9Logo,
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => Text(
                        SettingsController.instance.settings.value.appName,
                        style: Theme.of(context).textTheme.headlineLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('MENU', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                    // Menu Items
                    const TMenuItem(route: TRoutes.dashboard, icon: Iconsax.status, itemName: 'Panel'),
                    const TMenuItem(route: TRoutes.media, icon: Iconsax.image, itemName: 'Multimedia'),
                    const TMenuItem(route: TRoutes.banners, icon: Iconsax.picture_frame, itemName: 'Banners'),
                    const TMenuItem(route: TRoutes.products, icon: Iconsax.shopping_bag, itemName: 'Productos'),
                    const TMenuItem(route: TRoutes.categories, icon: Iconsax.category_2, itemName: 'Categorias'),
                    const TMenuItem(route: TRoutes.brands, icon: Iconsax.dcube, itemName: 'Marcas'),
                    const TMenuItem(route: TRoutes.customers, icon: Iconsax.profile_2user, itemName: 'Clientes'),
                    const TMenuItem(route: TRoutes.orders, icon: Iconsax.box, itemName: 'Pedidos'),
                    const TMenuItem(route: TRoutes.coupons, icon: Iconsax.code, itemName: 'Cupones'),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text('OTROS', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                    // Other menu items
                    const TMenuItem(route: TRoutes.profile, icon: Iconsax.user, itemName: 'Perfil'),
                    const TMenuItem(route: TRoutes.settings, icon: Iconsax.setting_2, itemName: 'Configuración'),
                    const TMenuItem(route: 'logout', icon: Iconsax.logout, itemName: 'Salir'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
