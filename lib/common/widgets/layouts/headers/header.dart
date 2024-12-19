import 'package:cwt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../features/personalization/controllers/user_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../appbar/appbar.dart';
import '../../images/t_rounded_image.dart';
import '../../shimmers/shimmer.dart';

/// Header widget for the application
class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({
    super.key,
    required this.scaffoldKey,
  });

  /// GlobalKey to access the Scaffold state
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Container(
      /// Background Color, Bottom Border
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
      child: TAppBar(
        /// Mobile Menu
        leadingIcon: !TDeviceUtils.isDesktopScreen(context) ? Iconsax.menu : null,
        leadingOnPressed: !TDeviceUtils.isDesktopScreen(context) ? () => scaffoldKey.currentState?.openDrawer() : null,
        title: Row(
          children: [
            /// Search
            if (TDeviceUtils.isDesktopScreen(context))
              SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal), hintText: 'Buscar...'),
                ),
              ),
          ],
        ),
        actions: [
          // Search Icon on Mobile
          if (!TDeviceUtils.isDesktopScreen(context)) IconButton(icon: const Icon(Iconsax.search_normal), onPressed: () {}),

          // Notification Icon
          IconButton(icon: const Icon(Iconsax.notification), onPressed: () {}),
          const SizedBox(width: TSizes.spaceBtwItems / 2),

          /// User Data
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// User Profile Image
              Obx(
                () => TRoundedImage(
                  width: 40,
                  padding: 2,
                  height: 40,
                  fit: BoxFit.cover,
                  imageType: controller.user.value.profilePicture.isNotEmpty ? ImageType.network : ImageType.asset,
                  image: controller.user.value.profilePicture.isNotEmpty ? controller.user.value.profilePicture : TImages.user,
                ),
              ),

              const SizedBox(width: TSizes.sm),

              /// User Profile Data [Hide on Mobile]
              if (!TDeviceUtils.isMobileScreen(context))
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.loading.value
                          ? const TShimmerEffect(width: 50, height: 13)
                          : Text(controller.user.value.fullName, style: Theme.of(context).textTheme.titleLarge),
                      controller.loading.value
                          ? const TShimmerEffect(width: 70, height: 13)
                          : Text(controller.user.value.email, style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
