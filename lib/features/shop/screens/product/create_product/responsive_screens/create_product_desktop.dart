import 'package:cwt_ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../widgets/additional_images.dart';
import '../widgets/attributes_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/brand_widget.dart';
import '../widgets/categories_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/thumbnail_widget.dart';
import '../widgets/title_description.dart';
import '../widgets/variations_widget.dart';
import '../widgets/visibility_widget.dart';

class CreateProductDesktopScreen extends StatelessWidget {
  const CreateProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());

    return Scaffold(
      bottomNavigationBar: const ProductBottomNavigationButtons(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Crear Producto',
                breadcrumbItems: [TRoutes.products, 'Crear Producto'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Create Product
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: TDeviceUtils.isTabletScreen(context) ? 2 : 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Information
                        const ProductTitleAndDescription(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Stock & Pricing
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Heading
                              Text('Existencia y precio', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwItems),

                              // Product Type
                              const ProductTypeWidget(),
                              const SizedBox(height: TSizes.spaceBtwInputFields),

                              // Stock
                              const ProductStockAndPricing(),
                              const SizedBox(height: TSizes.spaceBtwSections),

                              // Attributes
                              ProductAttributes(),
                              const SizedBox(height: TSizes.spaceBtwSections),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Variations
                        const ProductVariations(),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.defaultSpace),

                  // Sidebar
                  Expanded(
                    child: Column(
                      children: [
                        // Product Thumbnail
                        const ProductThumbnailImage(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Product Images
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Imagenes del producto', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              ProductAdditionalImages(
                                additionalProductImagesURLs: controller.additionalProductImagesUrls,
                                onTapToAddImages: () => controller.selectMultipleProductImages(),
                                onTapToRemoveImage: (index) => controller.removeImage(index),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Product Brand
                        const ProductBrand(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Product Categories
                        const ProductCategories(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Product Visibility
                        const ProductVisibilityWidget(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
