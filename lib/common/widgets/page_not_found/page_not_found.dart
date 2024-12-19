import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/routes.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../layouts/templates/site_layout.dart';

class TPageNotFound extends StatelessWidget {
  const TPageNotFound({
    super.key,
    this.isFullPage = false,
    this.title = 'Well, This is Awkward...',
    this.subTitle =
    'It seems we couldn’t find any records here. Maybe they’re off on an adventure or just hiding really well. Try again or check back later!'
  });

  final bool isFullPage;
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      useLayout: !isFullPage,
      desktop: Center(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const SizedBox(width: 400, height: 400, child: Image(image: AssetImage(TImages.errorIllustration))),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(title, style: Theme
                  .of(context)
                  .textTheme
                  .headlineLarge, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(subTitle, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed(TRoutes.dashboard),
                  label: const Text('Take Me Home!'),
                  icon: const Icon(Iconsax.home),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
